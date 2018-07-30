class Admin::UsersController < ApplicationController
  before_action :find_user, only: [:active_leader]

  def index
    if current_user.admin?
      member
      leader
      noleader
    else
      redirect_to root_path
    end
  end

  def active_leader
    if @user.update_attributes activated: true
      flash[:success] = t "flash.user_updated"
    else
      flash[:danger] = t "flash.cant_active"
    end
    redirect_to admin_users_path
  end

  def find_user
    @user = User.find params[:user_id]
    return if @user
    redirect_to root_path
    flash[:danger] = t "flash.cant_find_user"
  end

  private

  def member
    @member = User.where(role: 2)
                  .all.paginate(page: params[:member_page],
                                per_page: Settings.users.per_page)
  end

  def leader
    @leader_activated = User.where(role: 1, activated: true)
                            .all.paginate(page: params[:leader_page],
                                          per_page: Settings.users.per_page)
  end

  def noleader
    @leader_no_active = User.where(role: 1, activated: false)
                            .all.paginate(page: params[:noleader_page],
                                          per_page: Settings.users.per_page)
  end
end
