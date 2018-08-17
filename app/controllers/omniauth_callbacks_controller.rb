class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      flash[:notice] = t "devise.sessions.signed_in"
      @user.role = "member"
      @user.activated = 1
      @user.skip_confirmation!
      sign_in_and_redirect @user, event: authenticate_user!
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end
end
