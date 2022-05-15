Rails.application.routes.draw do
  devise_for :users
  root to: 'themes#index'
  get    '/:user_name' => 'users#show', as: 'user'
  get    '/:user_name/themes/new' => 'themes#new', as: 'new_theme'
  post   '/:user_name' => 'themes#create', as: 'themes'
  get    '/:user_name/themes/:theme_hashid' => 'themes#show', as: 'theme'
  get    '/:user_name/themes/:theme_hashid/edit' => 'themes#edit', as: 'edit_theme'
  get    '/:user_name/themes/:theme_hashid/edit/new' => 'links#new', as: 'new_theme_link'
  post   '/:user_name/themes/:theme_hashid/edit' => 'links#create', as: 'theme_links'
  patch  '/:user_name/themes/:theme_hashid' => 'themes#update', as: 'update_theme'
end
