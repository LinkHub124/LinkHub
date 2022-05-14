Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get '/:user_name' => 'users#show', as: 'user'
  get '/:user_name/themes/new' => 'themes#new', as: 'new_theme'
  post '/:user_name/themes/new' => 'themes#create', as: 'themes'
  get '/:user_name/themes/:theme_hashid' => 'themes#show', as: 'theme'
end
