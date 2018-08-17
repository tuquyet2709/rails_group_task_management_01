class TasksController < ApplicationController
  before_action :find_task, :check_task_in_group,
    only: [:edit, :update, :show, :destroy]
  before_action only: [:create] do
    check_leader_group params[:task][:group_id]
    find_group params[:task][:group_id]
    check_members_exist
  end
  before_action only: [:show, :statistic] do
    check_leader_or_member params[:group_id]
    find_group params[:group_id]
  end
  before_action only: [:statistic, :destroy] do
    check_leader_group params[:group_id]
  end
  before_action :subtask_belongs_to_user,
    only: [:change_subtask, :estimate]

  def show
    @users = @group.members.page(params[:page])
                   .per Settings.users.per_page
  end

  def create
    @task = Task.new task_params.merge(done_tasks: 0)
    @task.subtasks.each do |subtask|
      subtask.done = Subtask.statuses[:not_started]
      subtask.estimate = 0
    end
    @task.remain_time = @task.end_date - 12.hours if @task.end_date
    task_save
    redirect_to group_path(@group.id)
  end

  def destroy
    @tasks = Task.where group_task_id: @task.group_task_id
    @tasks.each(&:destroy)
    flash[:info] = t "flash.deleted"
    redirect_to request.referrer || root_url
  end

  def add_user_to_subtask
    @subtask = Subtask.find_by id: params[:subtask][:id]
    @task = Task.find_by id: @subtask.task_id
    @group = Group.find_by id: @task.group_id
    return if @group.leader != current_user
    @subtask.update_attributes user_subtask_params
  end

  def task_save
    if @task.save
      flash[:info] = t "flash.add_task_successful"
    else
      flash[:danger] = @task.errors.full_messages
    end
  end

  def statistic
    @users = @group.members.paginate page: params[:page],
                                     per: Settings.users.per_page
    @users = @group.members.page(params[:page]).per Settings.users.per_page
    @task = Task.new
    @task_statistic = Task.where group_task_id: params[:id]
  end

  def change_subtask
    @task = Task.find_by id: @subtask.task_id
    check_done
    @task.save
    @subtask.done = params[:subtask][:status]
    @subtask.save
  end

  def check_done
    if params[:subtask][:status].to_i == Subtask.statuses[:completed]
      @task.done_tasks += 1
    elsif @subtask.done == Subtask.statuses[:completed]
      @task.done_tasks -= 1
    end
  end

  def estimate
    @subtask.estimate = params[:subtask][:estimate]
    @subtask.save
  end

  private

  def subtask_belongs_to_user
    @subtask = Subtask.find_by id: params[:subtask][:id]
    return if @subtask.user == current_user
    redirect_to root_path
    flash[:danger] = t "flash.dont_have_permission"
  end

  def user_subtask_params
    params.require(:subtask).permit :id, :user_id
  end

  def check_members_exist
    return unless @group.members.count.zero?
    redirect_to group_path(@group.id)
    flash[:danger] = t "flash.member_null"
  end

  def find_group group_id
    @group = Group.find_by id: group_id
    return if @group
    redirect_to root_path
    flash[:danger] = t "flash.cant_find_group"
  end

  def task_params
    params.require(:task).permit :group_id,
      :title, :content, :start_date, :end_date,
      subtasks_attributes: [:task_id, :content, :done]
  end

  def leader_of_group group_id
    group = Group.find_by id: group_id
    return false unless group
    group.leader == current_user
  end

  def find_task
    @task = Task.find_by id: params[:id]
    return if @task
    redirect_to group_path
    flash[:danger] = t "flash.cant_find_task"
  end

  def check_task_in_group
    return if @task.group_id == params[:group_id].to_i
    redirect_to group_path
    flash[:danger] = t "flash.not_true_group"
  end

  def check_leader_group group_id
    return if leader_of_group group_id
    redirect_to current_user
    flash[:danger] = t "flash.you_are_not_leader"
  end

  def find_group_with_id
    @group = Group.find_by id: params[:group_id]
  end

  def change_subtask_params
    params.require(:subtask).permit :subtask_id, :group_id
  end

  def check_leader_or_member group_id
    return if leader_of_group group_id
    return unless GroupMember.find_by(group_id: group_id,
                                      member_id: current_user.id).blank?
    redirect_to current_user
    flash[:danger] = t "flash.cant_access_group"
  end
end
