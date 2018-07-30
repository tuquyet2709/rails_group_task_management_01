class Admin::UsersController < ApplicationController
  def index
    if current_user.admin?
      member
      leader
      noleader
    else
      redirect_to root_path
    end
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
