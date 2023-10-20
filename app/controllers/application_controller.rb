class ApplicationController < ActionController::Base
    before_action :authenticate
    private
    def authenticate
        return redirect_to :login_path unless session[:user_id].present?
        redirect_to :login_path unless current_user.present?
    end
    
    def current_user
        return @current_user unless @current_user.nil?
        @current_user ||= User.find_by(id: session[:user_id])
      end
end
