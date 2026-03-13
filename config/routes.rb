BeautifulPhotons::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :photos
      resources :galleries do
        resources :photos, controller: "gallery_photos", only: [ :create ], as: :photos
      end
    end
  end
end
