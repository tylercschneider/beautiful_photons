BeautifulPhotons::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :photos, only: [ :create ]
    end
  end
end
