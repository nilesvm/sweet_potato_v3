Rails.application.routes.draw do

  root :to => 'pages#home'

  get '/about', to: 'pages#about', as: 'about'
  get '/contact', to: 'pages#contact', as: 'contact'
  get '/help', to: 'pages#help', as: 'help'
  get '/terms-and-conditions', to: 'pages#terms', as: 'terms'
  get '/privacy', to: 'pages#privacy', as: 'privacy'

  # Events
  get '/events', to: 'events#index', as: 'event_index'
  get '/events/:slug', to: 'events#detail', as: 'event_detail'

  namespace :admin do
    resources :events
  end

  # mount Fae below your admin namespec
  mount Fae::Engine => '/admin'


  match "*path" => 'pages#error404', via: [:get, :post]

end
