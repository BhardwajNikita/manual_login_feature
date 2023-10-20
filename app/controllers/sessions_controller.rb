class SessionsController < ApplicationController
  skip_before_action :authenticate
  def new
  end

  def create 
    user = User.authenticate(params[:user][:email], params[:user][:password])

    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = 'Invalid email or password.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
