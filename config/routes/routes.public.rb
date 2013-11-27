BDZAdmin::Application.routes.draw do

  # BEGIN PUBLIC NAMESPACE
  namespace :public do 
    resources :festival_applications do
      member do 
        get :step2
        get :finalize
      end
      resources :festival_pieces 
    end
    resources :event_meals
    resources :event_cards
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
