Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users
  resources :posts do
    member do
      # member : 자동으로 posts라는 얘 뒤에 id를 붙여주고 그 뒤에 create_comment나 like_post를 붙여준다.
      # ex) (/posts/:id/{내가 설정한 url})
      post '/create_comment' => 'posts#create_comment', as: 'create_comment_to'
      post '/like_post' => 'posts#like_post', as: 'like_to'
    end
    collection do
      # /posts/{내가 설정한 url}
      delete '/:comment_id/destroy_comment' => 'posts#destroy_comment', as: 'destroy_comment'
    end
  end



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
