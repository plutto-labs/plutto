class HomeController < ApplicationController
  before_action :authenticate_admin_user, only: [:admin]

  def index; end

  def admin; end

  private

  def authenticate_admin_user
    redirect_to root_path if current_admin_user.blank?
  end
end
