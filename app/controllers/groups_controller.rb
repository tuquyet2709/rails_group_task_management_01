class GroupsController < ApplicationController
  before_action :find_group, only: [:show, :seach]
  before_action only: [:add_member] do
    check_leader_group params[:group_member][:group_id]
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.lead_groups.build group_params
    if @group.save
      flash[:info] = t "flash.create_user_successful"
    else
      flash[:danger] = t "flash.create_group_erorr"
    end
    redirect_to current_user
  end

  def show
    check_leader_or_member params[:id]
    @users = @group.members.paginate page: params[:page],
                                     per_page: Settings.users.per_page
    @task = Task.new
    @task.subtasks.build
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

  def search
    search_name = params[:search][:name]
    @users = User
             .search_by_name(search_name).paginate page: params[:page],
                                             per_page: Settings.users.per_page
    @group = Group.find_by id: params[:search][:group]
    render :show
  end

  private

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
    params.require(:group).permit :name, :description, :picture,
      :function
  end

  def find_group
    @group = Group.find_by id: params[:id]
    return if @group
    redirect_to root_path
    flash[:danger] = t "flash.cant_find_group"
  end
end
