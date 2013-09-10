Mihi::Application.routes.draw do

  # HTTPS_CONSTRAINTS ||= {protocol: 'https', subdomain: 'www'}
  # HTTP_CONSTRAINTS ||= {protocol: 'http', subdomain: 'www'}


  # scope({constraints: {}}.merge(Rails.env.test? ? {} : HTTPS_CONSTRAINTS)) do
  #   # Homepage, is a static page
  #   root to: 'static_pages#show', page: 'home'
  # end

  # Newsletters
  resources :exhibitions, only: [:index,:show] do
    resources :exhibition_pieces, path: '/piece', only: [:show]
  end

  # Static pages routing, use StaticPage to check if exists as constraint
  match "/*page" => "static_pages#show", as: :static_page, constraints: StaticPage.new, via: [:get]

  # Homepage, is a static page
  root to: 'static_pages#show', page: 'home'

end
