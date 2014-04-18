require 'sidekiq/web'

BDZAdmin::Application.routes.draw do




  resources :sepa_regeneration do
    collection do
      post :regenerate
    end
  end

  resources :homepages


  resources :festival_concerts do 
    member do
      get :programme
    end
  end
  resources :contact_events
  resources :board_contacts
  resources :subscribers

  resources :feature_requests do
    collection do 
      get :open
    end
  end

  resources :calendar_sync do
    collection do
      get :upload
    end
  end


  # MAGAZINE
  resources :magazine_samplings do
    collection do
      get :print_list
    end
  end

  resources :magazine_adverts
  resources :magazine_issues do
    member do 
      get :gen_advert_invoices
      get :gen_subscriber_invoices
      get :counts
    end
  end
  resources :advertisers

  #resources :mgl, :controller => "member_area"
    # BEGIN member namespace
  namespace :mgl do
    resources :orchestras
    resources :person_members

    resources :report_sheet_inputs do
      collection do 
        get :login
        post :submit_login
      end
      member do 
        get :step1
        get :step2
        get :step3
        get :step4
        put :submit1
        put :submit2
        put :submit3
        put :submit4
        put :finalize
        get :finalize
        get :confirm
        put :confirm
        post 'upload'
        get :delete_members
      end
    end
  end


  resources :report_sheet_inputs do
    collection do 
      get :lockdown
      get :generate
    end
  end

  resources :contact_people do
    resources :contact_events
  
  end


  resources :festival_pieces do
  
  end

  resources :festival_applications do
    collection do
      post :grp_list
      get :list
      get :permitted
    end
    member do 
      get :gen_invoice
    end
    resources :festival_pieces
    resources :festival_application_attachments
  end


  resources :event_cards  do
    collection do 
      get :gen_invoices
    end
  end

  resources :event_meals


  resources :uploaded_files

  match 'magazine_reports/calendar' => 'magazine_reports#calendar'
  match 'magazine_reports/counts' => 'magazine_reports#counts'

  match 'api/rsm/gen_data' => 'report_sheet_mailings#gen_data'
  match 'api/rsm/gen_mailings' => 'report_sheet_mailings#gen_mailings'

  resources :uploads

  get "errors/error_404"

  get "errors/error_500"

  resources :contacts
  resources :honor_members
  resources :member_events

  resources :distinctions do 
  member do
    get :gen_invoice
  end
  end

  resources :classifieds do
    collection do 
      get :inactive
      get :public
    end
    member do 
      get :publish
    end
  end

  resources :advertisements

  #devise_for :users, :controllers => {:sessions => 'sessions'}
  devise_for :users

  resources :users, :path => :accounts

  #resources :users
  resources :member_account_bookings



  get 'member_report' => 'member_report#index'
  get 'member_report/by_lv' => 'member_report#by_lv'

  match 'home/member_data' => 'home#member_data'
  match 'home/reference_data' => 'home#reference_data'
  match 'home/admin_data' => 'home#admin_data'
  match 'home/public_data' => 'home#public_data'
  match 'home/landing_page' => 'home#landing_page'
  match 'home/magazine_data' => 'home#magazine_data'
  match 'home/festival_data' => 'home#festival_data'
  match 'home/cron' => 'home#cron'

  match 'modify_pdf' => 'modify_pdf#index'

  match 'about' => 'about#index'
  match 'config' => 'about#settings'

  match 'custom_info_mail' => 'custom_info_mail#index'
  match 'custom_info_mail/kasitest' => 'custom_info_mail#kasitest'
  match 'custom_info_mail/send_mail' => 'custom_info_mail#send_mail'

  resources :festival_mails do
    collection do 
      get :index
      get :invoices
      post :send_mails
      post :send_invoices
    end
  end

  # partly public (except for edit functions)


  resources :functions do 
      collection do 
        get :public
      end
  end
  resources :states
  resources :regional_organizations  do 
    resources :functions do
    end
    member do
      get :members
      get :fee_shares
      get :orch
      get :person
          get :oddset_report
      end
    collection do
      get :create_annual_payment
      get :share_overview
    end
    resources :regional_organization_bookings, :as => :acct_bookings do
    member do 
      get 'download'
    end
  end
  end
  resources :tariffs


#confidential
#  resources :users
  resources :report_sheets do
    collection do 
      get 'payed'
      get 'final'
      get 'not_final'
      get 'analysis'
    end
  end

  resources :person_members do
    resources :member_events do
      member do
        get 'download'
      end
    end

    resources :member_account_bookings do
      member do 
        get 'download'
      end
    end

    # person member collections
    collection do 
      get :nopayment
      get :notinvoiced
      get :magazine
      get :addresses
    end
  end
  
  resources :orchestras do
    member do 
     get :gen_rsi
     get :rsi_login
    end

    resources :uploaded_files

    resources :report_sheets do 
      collection do
        get :copy_from_last_year
      end
    end

    resources :member_account_bookings do
      member do 
        get 'download'
      end
    end
    resources :member_events do
      member do
        get 'download'  
      end
    end

    resources :orchestra_members do
      collection do 
        get 'delete_all'
        get 'check_double'
        get 'upload_report'
        post 'upload'
      end
      member do
        get 'exchange'
      end
    end

    resources :orchestra_contacts
    resources :report_sheets do 
      member do 
        get :update_double_members
      end
    end
    resources :distinctions do
      member do
        get :gen_invoice
      end
    end
    collection do 
      get :noreport
      get :nopayment
      get :notinvoiced
      get :gema
      get :magazine
      get :addresses
      get :notyetemailed
    end
    
  end
  # ORCHESTRA END

  # reports
  namespace :reports do
    resources :gema
    resources :member_account_bookings
    resources :new_members
  end

  resources :concerts do
    collection do 
    get :inactive
  end
  member do
    get :publish
  end
  end

  resources :ensemble_concerts do
  collection do
    get :inactive
  end
  member do
    get :publish
  end
  end

  resources :ensembles do
    collection do 
      get :inactive
    end
    resources :ensemble_concerts do
      collection do
        get :inactive
      end
      member do
        get :publish
      end
    end
  end


  # the admin  equivalent of the public entities
    resources :addresses
    resources :courses do
    member do 
      get :publish
    end
    collection do 
      get :inactive
    end
    end

    resources :honor_members

    resources :ensembles do
    resources :ensemble_concerts
    end

    resources :concerts do
    collection do 
      get :inactive
    end
    end

    resources :composers
    resources :contests do
    collection do
      get :inactive
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
    resources :urls do
    collection do
      get :inactive
    end
      member do
      get :confirm
    end
    end

    resources :url_categories do
      resources :urls
    end


# automated controllers 
  namespace :cron do
   match 'invoices/gen_all' => 'invoices#gen_all'
   match 'invoices/gen_orchestras' => 'invoices#gen_orchestras'
   match 'invoices/gen_persons' => 'invoices#gen_persons'
   match 'invoices/ping' => 'invoices#ping'
    match 'lv_dtaus/index' => 'lv_dtaus#index'
    match 'reminders/report_sheet' => 'reminders#report_sheet'
    match 'reminders/payment' => 'reminders#payment'
    match 'cancellations' => 'batch#cancellations'

    get 'cleanup/remove_resigned' => 'cleanup#remove_resigned'
  # TODO: These aren't resources!
    resources :mails
    resources :downloads
  end


  match 'member_tools/kto_blz_to_iban_bic' => 'member_tools#kto_blz_to_iban'
  match 'member_tools/iban_calculator' => 'member_tools#iban_calculator'
  get "home/index"

  get 'reports/youth_addresses', to: 'reports/youth_addresses#index', defaults: { format: 'ods' }


  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#landing_page"


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  # login and logout urls ...
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  get "/edit_password" => "devise/passwords#edit"
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

end
