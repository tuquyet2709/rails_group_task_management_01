class GroupsController < ApplicationController
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

  private
  def group_params
    params.require(:group).permit :name, :description, :picture,
      :function
  end
end
