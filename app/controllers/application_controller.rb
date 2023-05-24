class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_host
  include ActiveRecord::Sanitization::ClassMethods
  # include DeviseTokenAuth::Concerns::User
  # include DeviseTokenAuth::Concerns::ActiveRecordSupport
  # include DeviseTokenAuth::Concerns::User
  # include DeviseTokenAuth::Concerns::SetUserByToken

  layout 'application_no_header', only: [:terms, :policy]

  protect_from_forgery with: :null_session

  
  skip_before_action :verify_authenticity_token
  helper_method :current_user, :user_signed_in?

  unless Rails.env.development? # 本番環境のみでの実行.
    rescue_from Exception, with: :render500
    rescue_from ActiveRecord::RecordNotFound,   with: :render404
    rescue_from ActionController::RoutingError, with: :render404
  end

  # GET  '/*not_found' => 'application#routing_error'
  # POST '/*not_found' => 'application#routing_error'
  # Description: 404エラー、500エラーを返す.
  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  # Description: 利用規約を表示.
  def terms
    render 'layouts/_terms.html.erb'
  end

  # Description: プライバシーポリシーを表示.
  def policy
    render 'layouts/_policy.html.erb'
  end

  private

  # Description: 404エラーを返す.
  def render404(e = nil)
    logger.info "Rendering 404 with excaption: #{e.message}" if e
    render 'errors/404.html', status: :not_found
  end

  # Description: 500エラーを返す.
  def render500(e = nil)
    logger.error "Rendering 500 with excaption: #{e.message}" if e
    render 'errors/500.html', status: :internal_server_error
  end

  # Description: メール送信時の前処理.
  def set_host
    Rails.application.routes.default_url_options[:host] = request.host_with_port
  end

  # Description: match_listのどれかに検索ワードが引っかかるか.
  def match_keyword?(search_text, match_list)
    return match_list.any?{ |match| match =~ /^.*#{sanitize_sql_like(search_text)}.*/ }
  end

  protected

  MAX_THEMES_PER_PAGE = 10 # 1ページに表示されるテーマ数を制限

  # Description: ユーザー登録・更新時に特定のデータを許可する.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :agreement])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name, :email, :provider])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:name, :email, :introduction, :profile_image, :github_id, :twitter_id, :facebook_id,
                                             :homepage_url, :agreement])
  end
end
