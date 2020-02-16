Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.
  namespace :api do
    namespace :v1 do
      resources :posts do
        get 'ip_list', on: :collection
      end
    end
  end
end
