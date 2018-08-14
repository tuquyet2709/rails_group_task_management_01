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

  def show
    @users = @group.members.page(params[:page])
                   .per Settings.users.per_page
  end

  def create
    group_taskid = generate_group_task_id
    @group.members.each do |member|
      @task = Task.new task_params.merge(member_id: member.id,
                                         done_tasks: 0,
                                         group_task_id: group_taskid)
      @task.subtasks.each do |subtask|
        subtask.done = 0
      end
      @task.remain_time = @task.end_date - 12.hours if @task.end_date
      task_save
    end
    redirect_to group_path(@group.id)
  end

  def destroy
    @tasks = Task.where group_task_id: @task.group_task_id
    @tasks.each(&:destroy)
    flash[:info] = t "flash.deleted"
    redirect_to request.referrer || root_url
  end

  def task_save
    if @task.save
      flash[:info] = t "flash.add_task_successful"
      @group.members.each do |member|
        member.sent_mail_deadline @task
      end
    else
      flash[:danger] = @task.errors.full_messages
    end
  end

  def statistic
    @users = @group.members.paginate page: params[:page],
                                     per: Settings.users.per_page
    @task = Task.new
    @task_statistic = Task.where group_task_id: params[:id]
  end

  def change_subtask
    @subtask = Subtask.find_by id: params[:subtask][:subtask_id]
    @subtask.update_attribute :done, !@subtask.done?
    @task = Task.find_by id: @subtask.task_id
    @task.done_tasks = @task.subtasks.where(done: true).count
    @task.save
    respond_to do |format|
      format.js
      format.html
    end
  end

  private

  def check_members_exist
    return unless @group.members.count.zero?
    redirect_to group_path(@group.id)
    flash[:danger] = t "flash.member_null"
  end

  def generate_group_task_id
    return 1 if Task.last.blank?
    Task.last.group_task_id + 1
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
