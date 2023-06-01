class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      session[:current_user_id] = user.id
      redirect_to "/"
    else
      flash[:danger] = user.errors.full_messages
      redirect_to signup_path
    end
  end

  private
  def user_params
    params.require(:user)
          .permit(:username, :email, :password, :password_confirmation)
  end
end
