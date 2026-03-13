BeautifulPhotons::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :photos, only: [ :index, :show, :create, :update ]
    end
  end
end
