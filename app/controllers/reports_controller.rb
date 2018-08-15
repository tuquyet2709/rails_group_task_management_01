class ReportsController < ApplicationController
  before_action :logged_in?, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @report = current_user.reports.build report_params
    authorize! :create, @report
    if @report.save
      flash[:success] = t "report.create"
      list_user = current_user.followers.ids
      ActionCable.server.broadcast "report_channel",
        content: render_to_string(partial: "reports/report", object: @report),
        list_user: list_user,
        current_user: current_user.id
    else
      @feed_items = []
      flash[:danger] = t "flash.destroy_report"
    end
  end

  def destroy
    authorize! :destroy, @report
    @report.destroy
    flash[:success] = t "flash.destroy_report"
    redirect_to current_user
  end

  private

  def report_params
    params.require(:report).permit :content, :task_content, :subtask_content
  end

  def correct_user
    @report = current_user.reports.find_by id: params[:id]
    redirect_to root_url unless @report.present?
  end
end
