# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :markets, only: [:index, :show] do
    collection do
      get :crypto_market_cap
    end
  end
end
