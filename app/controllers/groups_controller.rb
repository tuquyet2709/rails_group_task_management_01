class GroupsController < ApplicationController
  before_action :find_group_member, only: [:remove_member]
  before_action :find_group, only: [:show, :seach, :destroy, :edit, :update]
  before_action only: [:destroy, :edit, :update] do
    check_leader_group params[:id]
  end
  before_action only: [:add_member, :remove_member] do
    check_leader_group params[:group_member][:group_id]
  end

  def new
    @group = Group.new
  end

  def edit; end

  def update
    if @group.update_attributes group_params
      flash[:info] = t "flash.update_successful"
    else
      flash[:danger] = @group.errors.full_messages
    end
    redirect_to @group
  end

  def create
    @group = current_user.lead_groups.build group_params
    authorize! :create, @group
    if @group.save
      flash[:info] = t "flash.create_user_successful"
    else
      flash[:danger] = @group.errors.full_messages
    end
    redirect_to current_user
  end

  def show
    check_leader_or_member params[:id]
    @users = @group.members.paginate page: params[:page],
                                     per_page: Settings.users.per_page
    @task = Task.new
    return if current_user.leader?
    @user_tasks = current_user.tasks
                              .where(group_id: @group.id)
                              .order updated_at: :desc
  end

  def index
    @current_groups = current_user.groups
  end

  def add_member
    member = GroupMember.new group_member_params
    if member.save
      flash[:info] = t "flash.add_user_successful"
    else
      flash[:danger] = t "flash.add_user_eror"
    end
    group = Group.find_by id: params[:group_member][:group_id]
    redirect_to group
  end

  def remove_member
    @group_member.destroy
    flash[:info] = t "flash.deleted"
    redirect_to request.referrer || root_url
  end

  def destroy
    @group.destroy
    flash[:info] = t "flash.deleted"
    redirect_to request.referrer || root_url
  end

  def search
    search_name = params[:search][:name]
    @users = User
             .search_by_name(search_name)
             .paginate page: params[:page],
                           per_page: Settings.users.per_page
    @group = Group.find_by id: params[:search][:group]
    @task = Task.new
    render :show
  end

  private

  def is_leader?
    return if current_user.leader?
    flash[:danger] = t "flash.you_are_not_leader"
    redirect_to current_user
  end

  def find_group_member
    @group_member = GroupMember
                    .find_by group_id: params[:group_member][:group_id],
                                 member_id: params[:group_member][:member_id]
    return if @group_member
    flash[:danger] = t "flash.cant_find_user"
    redirect_to request.referrer || root_url
  end

  def group_member_params
    params.require(:group_member).permit :member_id, :group_id
  end

  def leader_of_group group_id
    Group.find_by(id: group_id).leader == current_user
  end

  def check_leader_group group_id
    return if leader_of_group group_id
    redirect_to current_user
    flash[:danger] = t "flash.you_are_not_leader"
  end

  def check_leader_or_member group_id
    return if leader_of_group group_id
    return unless GroupMember.find_by(group_id: group_id,
                                      member_id: current_user.id).blank?
    redirect_to current_user
    flash[:danger] = t "flash.cant_access_group"
  end

  def group_params
    params.require(:group).permit :name, :description,
      :function
  end

  def find_group
    @group = Group.find_by id: params[:id]
    return if @group
    redirect_to root_path
    flash[:danger] = t "flash.cant_find_group"
  end
end
