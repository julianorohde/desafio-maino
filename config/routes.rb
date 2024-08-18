# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  root 'pages#index'
  get 'pages/index'
  mount Sidekiq::Web => '/sidekiq'

  resource :eletronic_invoice do
    post :create, on: :collection
    get :export, on: :collection
    get :index
  end
end
