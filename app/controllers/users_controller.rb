class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_param
    if @user.save
      log_in @user
      flash[:info] = t "flash.create_user_successful"
      redirect_to root_path
    else
      flash.now[:danger] = t "flash.create_user_eror"
      render :new
    end
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    redirect_to root_path
    flash[:danger] = t "flash.cant_find_user"
  end

  def user_param
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
