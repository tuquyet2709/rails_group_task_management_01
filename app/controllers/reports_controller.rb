class ReportsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @report = current_user.reports.build report_params
    if @report.save
      flash[:success] = t "report.create"
      redirect_to request.referrer
    else
      @feed_items = []
      flash[:danger] = t "flash.destroy_report"
      respond_to do |format|
        format.html{redirect_to request.referrer}
        format.js
      end
    end
  end

  def destroy
    @report.destroy
    flash[:success] = t "flash.destroy_report"
    redirect_to request.referrer || root_url
  end

  private

  def report_params
    params.require(:report).permit :content
  end

  def correct_user
    @report = current_user.reports.find_by id: params[:id]
    redirect_to root_url if @report.present?
  end
end
