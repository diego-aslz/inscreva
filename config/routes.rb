Inscreva::Application.routes.draw do
  resources :wikis

  get "field_fills/:id/download", to: 'field_fills#download', as: :download_field_fill

  resources :subscriptions, only: [:receipt, :mine] do
    get "receipt", on: :member
    get "mine", on: :collection
  end
  resources :events, :shallow => true do
    resources :subscriptions
  end

  devise_for :users

  root to: "home#index"

  get "/:event", to: 'wikis#show', as: :event_wiki
end
