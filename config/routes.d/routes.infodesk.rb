BDZAdmin::Application.routes.draw do
  namespace :infodesk do
    resources :festival_applications do
      collection do 
        get :search
      end
    end
    resources :event_cards do 
      collection do   
        get :search
      end
    end
    resources :event_meals
    resources :quickaccess
  end
end
