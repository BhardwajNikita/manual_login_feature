class RegistrationsController < ApplicationController
  skip_before_action :authenticate
  def new
  end

  def create
    user = User.new(user_params)

    if user.save
      redirect_to login_path, notice: 'Account created successfully.'
    else
      flash[:error] = user.errors.full_messages.join(', ')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
