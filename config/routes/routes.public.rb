BDZAdmin::Application.routes.draw do

  # BEGIN PUBLIC NAMESPACE
  namespace :public do 
    resources :functions do
      collection do 
        get :federal
        get :states
        get :youth
      end
    end
    resources :competition_entries do
      collection do 
        get :participate
      end
      member do   
        get :success
      end
    end

    resources :event_cards do 
      collection do 
        get :order_form
        post :order_success
      end
    end
    resources :event_meals do 
      collection do 
        get :order_form
        post :order_success
      end
    end

    resources :festival_applications do
      member do 
        get :step2
        get :finalize
      end
      resources :festival_pieces 
    end
    resources :contacts
    resources :courses do
      collection do 
        get :inactive
        get :public
      end
    end

    resources :honor_members
    resources :countries do
      resources :states
    end

    resources :ensembles do
      resources :ensemble_concerts do
        member do
          get :publish
        end
      end
    end

    resources :concerts do
      collection do 
        get :inactive
        get :public
        get :magazine
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
      member do 
        get :publish
      end
    end

    resources :festivals do
    #    collection do 
    #      get :public
    #    end
      resources :concerts
    end
    resources :composers
    resources :universities

    resources :urls 
    resources :url_categories do
      resources :urls
    end
    resources :ensembles do
      resources :ensemble_concerts
    end
    resources :classifieds do
    end
  end # END NAMESPACE PUBLIC

end
