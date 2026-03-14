BeautifulPhotons::Engine.routes.draw do
  namespace :admin do
    resources :photos, only: [ :index ]
  end

  namespace :api do
    namespace :v1 do
      resources :photos
      resources :galleries do
        resources :photos, controller: "gallery_photos", only: [ :index, :create, :update, :destroy ], as: :photos
      end
    end
  end
end
