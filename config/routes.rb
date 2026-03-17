BeautifulPhotons::Engine.routes.draw do
  scope module: :admin do
    resources :photos, only: [ :index, :show, :new, :create, :edit, :update ]
    resources :standalones, only: [ :index, :show, :update ]
    resources :galleries, only: [ :index, :show, :new, :create ] do
      patch :reorder, on: :member
      post :add_photos, on: :member
      delete :remove_photo, on: :member
    end
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
