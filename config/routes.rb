Inscreva::Application.routes.draw do
  get "field_fills/:id/download", to: 'field_fills#download', as: :download_field_fill
  get 'locales/:locale' => 'locales#show', :as => :locale

  resources :subscriptions, only: [:receipt, :mine] do
    get "receipt", on: :member
    get "mine", on: :collection
  end
  resources :events, :shallow => true do
    resources :subscriptions
    resources :pages do
      get 'present', on: :member
    end
  end

  devise_for :users
  devise_scope :user do
    get 'registrations/edit' => 'devise/registrations#edit', :as => 'edit_registration'
    put 'registrations' => 'devise/registrations#update', :as => 'registration'
  end
  resources :users

  root to: "home#index"

  get "/:event", to: 'pages#present', as: :present_event_main_page
  get "/:event/:page", to: 'pages#present', as: :present_event_page
end
