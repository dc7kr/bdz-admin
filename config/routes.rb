RailsAdmin::Application.routes.draw do

  resources :classifieds

  resources :advertisements

  devise_for :users

  #entirely public 
  resources :home
  resources :about

  # partly public (except for edit functions)
  resources :courses do
	collection do 
		get :inactive
		get :public
	end
  end

  resources :concerts do
	collection do 
		get :inactive
		get :public
	end
  end

  resources :composers do
    collection do
      get :public
    end
  end

  resources :contests do
	collection do
		get :inactive
        get :public
	end
  end

  resources :festivals do
    collection do 
      get :public
    end
    resources :concerts
  end

  resources :functions
  resources :addresses
  resources :states
  resources :regional_organizations  do 
	member do
		get :members
    end 
  end
  resources :tariffs
  resources :composers
  resources :universities
  resources :honor_members

  resources :urls 

  resources :url_categories do
    resources :urls
  end

  resources :countries do
    resources :states
  end

  resources :ensembles do
	collection do 
		get :inactive
	end
  end


#confidential
#  resources :users
  resources :report_sheets

  resources :person_members do
    resources :member_account_bookings do
		member do 
			get 'download'
		end
    end
	collection do 
		get :nopayment
		get :notinvoiced
        get :magazine
	end
  end
  
  resources :orchestras do
    resources :member_account_bookings do
		member do 
			get 'download'
		end
    end
    resources :report_sheets
	collection do 
		get :noreport
		get :nopayment
		get :notinvoiced
        get :gema
        get :magazine
	end
  end
# reports
  namespace :reports do
    resources :gema
  end

  namespace :public do 
	resources :concerts, :contests
  end


# automatic controllers 
  namespace :cron do
    resources :invoices
    resources :reminders
	resources :mails
	resources :downloads
  end

  get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  # login and logout urls ...
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end

end
