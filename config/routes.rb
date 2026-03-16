BeautifulPhotons::Engine.routes.draw do
  resources :photos, only: [ :index, :show, :new, :create, :edit, :update ]
  resources :galleries, only: [ :index, :show ] do
    patch :reorder, on: :member
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
