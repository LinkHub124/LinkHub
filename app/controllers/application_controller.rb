class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_host

  def set_host
    Rails.application.routes.default_url_options[:host] = request.host_with_port
  end


  protected

  def configure_permitted_parameters
    # 新規登録時にemailの取得を許可
    devise_parameter_sanitizer.permit(:sign_up, keys:[:email])
    # 情報更新時にnicknameの取得を許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:email])
  end
end
