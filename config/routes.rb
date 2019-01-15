require 'sidekiq/web'

BDZAdmin::Application.routes.draw do

  resources :gema_events do 
    collection do 
      post :import
    end
  end
  mount CorikaInvoices::Engine, at: "/invoice_engine"

  get '/auth/:provider/callback', to: 'sessions#create'
  resources :orchestra_members do
    collection do
      get :search
    end
    member do
      get 'exchange'
    end
  end

  resources :competition_entries do

    collection do 
      get :drawable
      get :drawing
    end

    member do 
      get :winner
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
  namespace :magazine do
    resources :magazine_issues, :path => :issues, :as => :issues do
      resources :magazine_adverts, :path => :adverts, :as => :adverts, :shallow=>true
      member do 
        get :gen_advert_invoices
        get :counts
      end
    end
    resources :advertisers
    resources :samplings, controller: 'magazine_samplings' do
      collection do
        get :print_list
      end
    end
  end

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
        patch :submit1
        patch :submit2
        patch :submit3
        patch :submit4
        patch :finalize
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
      get :search
    end
    member do
      get :metadata
    end
  end

  resources :contact_people do
    resources :contact_events
  
  end

    resources :festival_pieces
    resources :festival_applications, param: :token do
      collection do
        post :grp_list
        get :list
        get :permitted
        get :participant_overview
        get :gen_participant_sheets
        get :open_issues
      end
      member do 
        get :gen_invoice
        get :gen_participant_sheet
      end
      resources :festival_pieces
      resources :festival_application_attachments
    end
    resources :event_cards  do
      member do 
        get :gen_invoice
        get :pickup
      end
      collection do 
        get :overview
        get :open_orders
      end
    end

    resources :event_meals do 
      collection do 
        get :arrival_overview
      end
    end


  resources :uploaded_files

  get 'magazine_reports/calendar' => 'magazine_reports#calendar'
  get 'magazine_reports/counts' => 'magazine_reports#counts'

  get 'api/rsm/gen_data' => 'report_sheet_mailings#gen_data'
  get 'api/rsm/gen_mailings' => 'report_sheet_mailings#gen_mailings'
  get 'api/rsm/test' => 'report_sheet_mailings#test'

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
    end
    member do 
      get :publish
    end
  end

  resources :advertisements

  #devise_for :users, :controllers => {:sessions => 'sessions'}
  devise_for :users, :skip => [:registrations]
  devise_for :members,  :controllers => {:registrations => "registrations"}, :path_prefix => 'mem'

  resources :users, :path => :accounts do
    collection do 
      get :for_admin_notify 
    end
  end

  #resources :users
  resources :member_account_bookings



  get 'member_report' => 'member_report#index'
  get 'member_report/by_lv' => 'member_report#by_lv'
  get 'member_report/report_sheet_stats' => 'member_report#report_sheet_stats'

  get 'home/member_data' => 'home#member_data'
  get 'home/reference_data' => 'home#reference_data'
  get 'home/admin_data' => 'home#admin_data'
  get 'home/public_data' => 'home#public_data'
  get 'home/landing_page' => 'home#landing_page'
  get 'home/magazine_data' => 'home#magazine_data'
  get 'home/festival_data' => 'home#festival_data'
  get 'home/cron' => 'home#cron'

  get 'modify_pdf' => 'modify_pdf#index'

  get 'about' => 'about#index'
  get 'config' => 'about#settings'

  get 'custom_info_mail' => 'custom_info_mail#index'
  get 'custom_info_mail/test' => 'custom_info_mail#test'
  post 'custom_info_mail/send_mail' => 'custom_info_mail#send_mail'
  get 'custom_info_mail/template_test' => 'custom_info_mail#template_test'

  resources :festival_mails do
    collection do 
      get :index
      get :invoices
      get :reservation_invoices
      post :send_mails
      post :send_invoices
      post :send_reservation_invoices
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
    resources :regional_organization_reports, :path => :reports do 
      collection do 
        get :index
        get :orch
        get :person
        get :members
        get :fee_shares
        get :oddset_report
        get :share_overview
      end
    end

    resources :orchestras do
      collection do 
        get :nopayment
        get :notinvoiced
      end
    end
    resources :person_members do
      collection do 
        get :nopayment
        get :notinvoiced
      end
    end

    resources :report_sheets
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
    resources :regional_organization_bookings, :shallow=>true do
      member do 
        get 'download'
      end
    end
    resources :member_account_bookings, :shallow=>true do
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
      get :nomail
      get :notinvoiced
      get :magazine
      get :addresses
    end
  end
  
  resources :orchestras do
    collection do 
      get :pro_musica
    end

    member do 
     get :gen_rsi
     get :rsi_login
    end

    resources :uploaded_files

    resources :report_sheets do 
      collection do
        get :copy_from_last_year
      end
      member do 
        get :update_from_members
        post :update_invoice
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
        post :exchange_all
        get 'check_double'
        get 'upload_report'
        post 'upload'
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
      get :lorch
      get :noreport
      get :nomail
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
      get :future
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
      get :future
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
   get 'invoices/gen_all' => 'invoices#gen_all'
   get 'invoices/gen_orchestras' => 'invoices#gen_orchestras'
   get 'invoices/gen_persons' => 'invoices#gen_persons'
   get 'invoices/gen_lorch' => 'invoices#gen_lorch'
   get 'invoices/ping' => 'invoices#ping'
    get 'lv_fee_bookings/index' => 'lv_fee_bookings#index'
    get 'reminders/report_sheet' => 'reminders#report_sheet'
    get 'reminders/payment' => 'reminders#payment'
    get 'cancellations' => 'batch#cancellations'

    get 'cleanup/remove_resigned' => 'cleanup#remove_resigned'
  # TODO: These aren't resources!
    resources :mails
    resources :downloads
  end


  get 'member_tools/kto_blz_to_iban_bic' => 'member_tools#kto_blz_to_iban'
  get 'member_tools/iban_calculator' => 'member_tools#iban_calculator'
  get "home/index"

  get 'reports/youth_addresses', to: 'reports/youth_addresses#index', defaults: { format: 'ods' }


  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#landing_page"


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # get ':controller(/:action(/:id(.:format)))'

  # login and logout urls ...
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  get "/edit_password" => "devise/passwords#edit"
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  namespace :adm do 
    resources :letter_file_regeneration
    resources :sepa_regeneration do
      collection do
        post :regenerate
        post :regenerate_by_date_and_type
      end
    end
    resources :member_account_bookings
  end
  # BEGIN PUBLIC NAMESPACE
  namespace :public do 
    resources :regional_organizations, :as => "lv" do 
      resources :orchestras 
      resources :concerts 
    end

    resources :honor_members

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

    resources :festival_applications, param: :token  do
      member do 
        get :step2
        get :finalize
      end
      collection do 
        get :closed
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

    resources :regional_organizations, :as => "lv" do
    end
  end # END NAMESPACE PUBLIC

  
end
