BeautifulPhotons::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :photos
      resources :galleries, only: [ :index ]
    end
  end
end
