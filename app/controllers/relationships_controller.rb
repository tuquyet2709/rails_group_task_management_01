class RelationshipsController < ApplicationController
  before_action :logged_in?

  def create
    @user = User.find_by id: params[:followed_id]
    @report_ano = user.reports.order_desc
                      .page(params[:page])
                      .per Settings.users.per_page
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  attr_reader :user
end
