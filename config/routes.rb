Service::Application.routes.draw do

  namespace :admin do resources :admins end

  devise_for :users

  resources :articles
  resources :user
  
  #resources :articles, :only => [:index, :show]
  resources :user, :only => [:index, :show, :delete]
  namespace :admin do
    root :to =>'articles#index'
    resources :articles
    resources :user
  end
  
  match '/:page' => 'pages#show'

  match '/videos' =>'articles#index'
  match '/videos/:id' =>'articles#show' 

  root :to => "articles#index"

  match ':controller(/:action(/:id(.:format)))'
end