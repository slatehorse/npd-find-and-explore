# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, path: 'admin/users', skip: %i[registrations]
  as :admin_user do
    get    '/admin/users/profile',        to: 'devise/registrations#edit',   as: :admin_user_root
    get    '/admin/users/edit(.:format)', to: 'devise/registrations#edit',   as: :edit_admin_user_registration
    patch  '/admin/users(.:format)',      to: 'devise/registrations#update', as: :admin_user_registration
    put    '/admin/users(.:format)',      to: 'devise/registrations#update'
    delete '/admin/users(.:format)',      to: 'devise/registrations#destroy'
    post   '/admin/users(.:format)',      to: 'devise/registrations#create'
  end

  namespace :admin do
    resource :categories, only: [] do
      get  :childless
      get  :tree
      post :sort
      get  :import
      post :preprocess
      post :import, to: 'categories#do_import'
      post :abort_import
      get  :reindex
      post :reindex, to: 'categories#do_reindex'
    end
    resources :categories
    resource :concepts, only: [] do
      get  :childless
      get  :reindex
      post :reindex, to: 'concepts#do_reindex'
    end
    resources :concepts
    resource :data_elements, only: [] do
      get  :orphaned
      get  :import
      post :preprocess
      post :import, to: 'data_elements#do_import'
      post :abort_import
    end
    resources :data_elements, only: %i[index show]
    resources :admin_users

    root to: 'categories#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '(/:locale)', locale: /en|cy/, defaults: { locale: 'en' } do
    resources :categories,  only: %i[index show]
    resources :concepts,    only: %i[show]
    resources :search,      only: %i[index]
    resources :data_tables, only: %i[show]
  end

  root to: 'categories#index'
end
