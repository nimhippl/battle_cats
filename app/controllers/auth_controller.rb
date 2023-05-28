class AuthController < ApplicationController
  def new

  end

  def signup

  end


  def create
    user = User.find_by_email(login_params[:email])
    if user.present? && user.authenticate(login_params[:password])
      session[:current_user] = user.id
      redirect_to '/dashboard'
    else
      flash[:error] = 'Wrong credentials'
      redirect_to login_path
    end
  end

  def destroy
    session[:current_user] = nil
    redirect_to root_path
  end

  private
  def login_params
    params.permit(:email, :password)
  end


  def user_params
    params.require(:user)
          .permit(:email, :username, :password, :password_confirmation)
  end
  end
