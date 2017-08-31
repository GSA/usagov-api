Rails.application.routes.draw do
 
  # all api endpoints will default to json
  namespace :api, :defaults => { :format => :json }do
    # version namespacing, really we will have seperate controllers / models for versions
    namespace :v1 do
      # get narrative content for now
      get 'usagov/narratives' => "text_assets#index"
      get 'usagov/narratives/:id' => "text_assets#show"
      get 'usagov/test' => "text_assets#test"

      get 'ip_address' => "ip_address#show"
      scope 'usagov' do
        resources :site_level_taxonomies, only: [:index, :show]

        resources :agency_taxonomies, only: [:index, :show]

        resources :asset_taxonomies, only: [:index, :show]

        resources :multimedia_assets, only: [:index, :show]

        resources :state_details, only: [:index, :show]

        resources :directory_records, only: [:index, :show] do

          collection do
            get "federal"
            get "bbb"
            get "state/:state" => "directory_records#state"
            get "consumer_agencies"
            get "autocomplete"
          end
        end
        
        resources :pages, only: [:index] do
          collection do
            get "usa_gov"
            get "gobierno_usa_gov"
            get "kids_usa_gov"
          end
        end


      end
    end
  end

  get 'swagger' => 'application#swagger'
  root 'application#swagger'
  
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
