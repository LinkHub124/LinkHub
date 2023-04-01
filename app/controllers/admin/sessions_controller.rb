# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :not_admin_permission
  
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private
  
  def not_admin_permission
    unless user_signed_in? && current_user.is_admin
      # 本当は404にしたい
      # redirect_to root_path
      render "public/errors/404.html", status: :not_found#, layout: "error"
    end
  end
end
