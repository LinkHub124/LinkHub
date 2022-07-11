class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_host
  
  layout 'app2', only: [:terms, :policy]


  #===================================================================
  unless Rails.env.development?
     rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def terms
    render "layouts/_terms.html.erb"
  end
  def policy
    render "layouts/_policy.html.erb"
  end

  private
  def _render_404(e = nil)
    logger.info "Rendering 404 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: "404 Not Found" }, status: :not_found
    else
      render "errors/404.html", status: :not_found#, layout: "error"
    end
  end

  def _render_500(e = nil)
    logger.error "Rendering 500 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: "500 Internal Server Error" }, status: :internal_server_error
    else
      render "errors/500.html", status: :internal_server_error#, layout: "error"
    end
  end
  
  def set_host
    Rails.application.routes.default_url_options[:host] = request.host_with_port
  end


  protected

  def configure_permitted_parameters
    # 新規登録時にemailの取得を許可
    devise_parameter_sanitizer.permit(:sign_up, keys:[:email, :agreement])
    # 情報更新時にnicknameの取得を許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :introduction, :profile_image, :github_id, :twitter_id, :facebook_id, :homepage_url, :agreement])
  end
end
