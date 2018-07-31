class TasksController < ApplicationController
  before_action :check_leader_group, :find_group, only: [:create]
  before_action :find_task, :check_task_in_group, :find_group_with_id,
                only: [:edit, :update, :show, :destroy]
  before_action :find_group_with_id, only: [:edit, :update, :show, :destroy]

  def new
    @task = Task.new
  end

  def show;
  end

  def create
    @group.members.each do |member|
      @task = Task.new task_params.merge(member_id: member.id)
      @task.subtasks.each do |subtask|
        subtask.done = Subtask.statuses[:not_started]
      end
      if @task.save
        flash[:info] = t "flash.add_task_successful"
      else
        flash[:danger] = t "flash.add_task_error"
      end
    end
    redirect_to current_user
  end

  def change_subtask
    @subtask = Subtask.find_by id: params[:subtask][:subtask_id]
    @subtask.update_attribute :done, !@subtask.done?
    redirect_to group_task_path(params[:subtask][:group_id], @subtask.task_id)
  end

  private

  def find_group
    @group = Group.find_by id: params[:task][:group_id]
    return if @group
    redirect_to root_path
    flash[:danger] = t "flash.cant_find_group"
  end

  def task_params
    params.require(:task).permit :group_id,
                                 :title, :content, :start_date, :end_date,
                                 subtasks_attributes: [:task_id, :content, :done]
  end

  def leader_of_group
    group = Group.find_by id: params[:task][:group_id]
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

  def check_leader_group
    return if leader_of_group
    redirect_to current_user
    flash[:danger] = t "flash.you_are_not_leader"
  end

  def find_group_with_id
    @group = Group.find_by id: params[:group_id]
  end

  def change_subtask_params
    params.require(:subtask).permit :subtask_id, :group_id
  end
end
