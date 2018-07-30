class TasksController < ApplicationController
  before_action :check_leader_group, :find_group, only: [:create]

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

  def check_leader_group
    return if leader_of_group
    redirect_to current_user
    flash[:danger] = t "flash.you_are_not_leader"
  end
end
