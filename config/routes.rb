# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  root 'pages#index'
  get 'pages/index'
  mount Sidekiq::Web => '/sidekiq'
end
