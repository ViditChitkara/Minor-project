class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def authorize_admin
    if user_signed_in? && !current_user.is_admin
      return redirect_to :root
    end
  end
end
