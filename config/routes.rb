BeautifulPhotons::Engine.routes.draw do
  scope module: :admin do
    resources :photos, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
      post :bulk_create, on: :collection
      delete :bulk_destroy, on: :collection
      patch :toggle_published, on: :member
    end
    resources :standalones, only: [ :index, :show, :update ] do
      member do
        get :edit_crop
        get :edit_mobile_crop
        get :change_photo
      end
    end
    resources :galleries, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
      member do
        patch :reorder
        get :add_photos_page
        post :add_photos
        delete :remove_photos
      end
    end
  end

  # Public turbo frame endpoint for standalone photos
  get "standalone_photo/:key", to: "standalone_photos#show", as: :standalone_photo

  namespace :api do
    namespace :v1 do
      resources :photos
      resources :galleries do
        resources :photos, controller: "gallery_photos", only: [ :index, :create, :update, :destroy ], as: :photos
      end
    end
  end
end
