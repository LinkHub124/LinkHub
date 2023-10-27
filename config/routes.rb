Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    # API認証用
    :omniauth_callbacks => 'users/omniauth_callbacks',
  }

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
        registrations: 'api/v1/auth/registrations'
      }
      namespace :auth do
        resources :sessions, only: %i[index]
      end
      # resources :test, only: %i[index]
      resources :themes, only: %i[index show]
      get '/users/:user_name' => 'users#show'
    end
  end

  root to: 'themes#index'
  get    '/followings' => 'themes#index_follow', as: 'index_follow'
  # get    '/timeline' => 'themes#timeline'
  get    '/search' => 'searches#search', as: 'search'
  get    '/terms' => 'application#terms', as: 'terms'
  get    '/policy' => 'application#policy', as: 'policy'
  # get    '/settings' => 'users/registrations#edit', as: 'edit_user'
  # patch  '/settings' => 'users#update', as: 'update_user'
  get    '/users/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
  patch  '/users/withdrawal' => 'users#withdrawal', as: 'withdrawal'
  get    '/tags' => 'tags#index', as: 'tags'
  get    '/tags/:tag_name' => 'tags#show', as: 'tag'
  get    '/:user_name' => 'users#show', as: 'user'
  get    '/:user_name/themes/new' => 'themes#new', as: 'new_theme'
  post   '/:user_name' => 'themes#create', as: 'themes'
  patch  '/:user_name/themes/:theme_hashid/:link_hashid/sort' => 'links#sort'
  patch  '/:user_name/themes/:theme_hashid/report' => 'themes#report', as: 'theme_report'
  get    '/:user_name/themes/:theme_hashid' => 'themes#show', as: 'theme'
  get    '/:user_name/themes/:theme_hashid/edit' => 'themes#edit', as: 'edit_theme'
  patch  '/:user_name/themes/:theme_hashid' => 'themes#update', as: 'update_theme'
  delete '/:user_name/themes/:theme_hashid' => 'themes#destroy', as: 'destroy_theme'
  get    '/:user_name/themes/:theme_hashid/edit/new' => 'links#new', as: 'new_theme_link'
  post   '/:user_name/themes/:theme_hashid/edit' => 'links#create', as: 'theme_links'
  get    '/:user_name/themes/:theme_hashid/edit/:link_hashid/edit' => 'links#edit', as: 'edit_theme_link'
  patch  '/:user_name/themes/:theme_hashid/edit/:link_hashid' => 'links#update', as: 'update_theme_link'
  delete '/:user_name/themes/:theme_hashid/edit/:link_hashid' => 'links#destroy', as: 'destroy_theme_link'
  post   '/:user_name/themes/:theme_hashid/favorites' => 'favorites#create', as: 'theme_favorites'
  delete '/:user_name/themes/:theme_hashid/favorites' => 'favorites#destroy'
  get    '/:user_name/favorites' => 'favorites#index', as: 'user_favorites'
  post   '/:user_name/relationships' => 'relationships#create', as: 'user_relationships'
  delete '/:user_name/relationships' => 'relationships#destroy'
  get    '/:user_name/followings' => 'relationships#followings', as: 'user_followings'
  get    '/:user_name/followers' => 'relationships#followers', as: 'user_followers'
  # get    '/*not_found' => 'application#routing_error'
  # post   '/*not_found' => 'application#routing_error'
end