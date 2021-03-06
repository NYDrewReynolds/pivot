Rails.application.routes.draw do
  root 'welcome#index'

  get 'cart/edit'
  patch 'cart/add_item/:id', to: 'cart#add_item', as: 'cart_add_item'
  patch 'cart/remove_item/:id', to: 'cart#remove_item', as: 'cart_remove_item'
  patch 'cart/update_quantity/:id', to: 'cart#update_quantity', as: 'cart_update_quantity'
  delete 'cart/destroy'

  resources :restaurants, except: [:index] do
    resources :items, only: [:show]
    get 'orders/', to:'users#show_restaurant_orders', as: 'orders'
    namespace :admin do
      resources :dashboard, only: [:index]
      resources :items, except: [:index]
      resources :categories
      resources :user_staff_roles
      resources :orders, only: [:index, :edit, :destroy]
      patch '/order/status/:id/:event', to: 'orders#update', as: 'order_status'
      patch '/orders/remove_item/:id/:item_id', to: 'orders#remove_item', as: 'order_remove_item'
      patch '/orders/update_quantity/:id/:item_id', to: 'orders#update_quantity', as: 'order_update_quantity'
      get '/orders/:status', to: 'orders#custom_show', as: 'order_custom_show'
    end
  end

  resources :users, except: [:index, :show]
  get '/users/orders', to: 'users#show_orders', as: 'user_orders'
  get '/users/restaurants', to: 'users#show_restaurants', as: 'user_restaurants'
  resources :orders, except: [:update, :edit, :destroy]

  resources :charges, only: [:new, :create]

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
