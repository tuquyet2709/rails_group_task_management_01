class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :find_user, only: [:edit, :update, :show, :destroy,
                                   :followers, :following, :upgrade_leader]

  def new
    @user = User.new
  end

  def create
    @user = if user_params[:role] == "member"
              User.new user_params.merge(activated: 1)
            else
              User.new user_params.merge(activated: 0)
            end
    if @user.save
      log_in @user
      flash[:info] = t "flash.create_user_successful"
      redirect_to root_path
    else
      flash.now[:danger] = t "flash.create_user_eror"
      render :new
    end
  end

  def show_member
    search_tasks_and_subtasks
    if current_user? @user
      find_report
    else
      @report_ano = @user.reports.order_desc
                         .page(params[:page])
                         .per Settings.users.per_page
    end
    render "show_member"
  end

  def find_report
    @reports = current_user.feed.order_desc
                           .page(params[:page])
                           .per Settings.users.per_page
    @q = @reports.search(params[:q])
    check_search
  end

  def check_search
    if params[:q].present?
      @reports = @q.result(distinct: true)
      @report = @reports.build
    else
      @report = current_user.reports.build
    end
  end

  def search
    return unless current_user.member?
    find_user
    search_tasks_and_subtasks
    find_report
    render "show_member"
  end

  def show
    show_admin if @user.admin?
    show_member if @user.member?
    if @user && @user.activated
      check_leader if @user.leader?
    else
      flash[:danger] = t "flash.wait_admin_activate"
      redirect_to root_url
    end
  end

  def show_admin
    if (current_user != @user) && !current_user.admin?
      redirect_to current_user
    else
      render "show_admin"
    end
  end

  def check_leader
    if (current_user != @user) && !current_user.admin?
      redirect_to current_user
    else
      @group = Group.new
      render "show_leader"
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "flash.user_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    can? :destroy, @user
    @user.destroy
    flash[:success] = t "flash.user_deleted"
    redirect_to admin_users_path
  end

  def following
    @title = t "follow.following"
    @users = @user.following
                  .page(params[:page])
                  .per Settings.users.per_page
    render "show_follow"
  end

  def followers
    @title = t "follow.follower"
    @users = @user.followers
                  .page(params[:page])
                  .per Settings.users.per_page
    render "show_follow"
  end

  def upgrade
    render "upgrade_leader"
  end

  def upgrade_leader
    @user.role = "leader"
    @user.activated = 0
    if @user.save
      flash[:success] = t "flash.upgrade_leader_success"
    else
      flash[:danger] = t "flash.upgrade_leader_danger"
    end
    redirect_to root_url
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    redirect_to root_path
    flash[:danger] = t "flash.cant_find_user"
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :role
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def search_tasks_and_subtasks
    @tasks = Task.where(member_id: current_user.id)
    @subtask = @tasks.map(&:subtasks).flatten
  end
end
