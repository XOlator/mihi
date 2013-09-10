Mihi::Application.routes.draw do

  # HTTPS_CONSTRAINTS ||= {protocol: 'https', subdomain: 'www'}
  # HTTP_CONSTRAINTS ||= {protocol: 'http', subdomain: 'www'}


  # scope({constraints: {}}.merge(Rails.env.test? ? {} : HTTPS_CONSTRAINTS)) do
  #   # Homepage, is a static page
  #   root to: 'static_pages#show', page: 'home'
  # end

  namespace :browse do
    resources :exhibitions, only: [:show] do
      resources :exhibition_pieces, path: '/piece', as: :piece, only: [:show] do
        get '/cache', action: :cache, on: :member
      end
    end
  end

  # Newsletters
  resources :exhibitions, only: [:index,:show] do
    resources :exhibition_pieces, path: '/piece', as: :piece, only: [:show]
  end

  # Static pages routing, use StaticPage to check if exists as constraint
  match "/*page" => "static_pages#show", as: :static_page, constraints: StaticPage.new, via: [:get]

  # Homepage, is a static page
  root to: 'static_pages#show', page: 'home'

end
