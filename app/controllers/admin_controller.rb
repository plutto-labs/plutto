class AdminController < ApplicationController
  before_action :authorize_admin!

  def login_as
    user = User.find(params[:id])

    sign_in user
    redirect_to admin_app_path
  end

  private

  def authorize_admin!
    raise StandardError.new 'You are not authorized to view this page' if current_admin_user.nil?
  end
end
