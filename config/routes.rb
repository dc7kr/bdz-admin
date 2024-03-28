# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  # custom errors
  match "/403", :to => "errors#forbidden", :via=>:all
  match "/404", :to => "errors#not_found", :via=>:all
  match "/500", :to => "errors#internal_server_error", :via=>:all

  # test for exception notification via Mail
  get 'test_exception_notifier' => 'application#test_exception_notifier'


  # Start page
  root :to => "home#landing_page"

  # login and logout urls ...
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    get "/edit_password" => "devise/passwords#edit"
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :gema_events do
    collection do
      post :import
    end
  end

  mount CorikaInvoices::Engine, at: "/invoice_engine", :as => 'invoice_engine'

  get '/auth/:provider/callback', to: 'sessions#create'

  resources :orchestra_members do
    collection do
      get :search
    end
    member do
      get 'exchange'
    end
  end

  resources :festival_concerts do
    member do
      get :programme
    end
  end

  resources :contact_events

  resources :feature_requests do
    collection do
      get :open
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

  resources :advertisements

  devise_for :users, :skip => [:registrations]
  devise_for :members,  :controllers => {:registrations => "registrations"}, :path_prefix => 'mem'

  resources :users, :path => :accounts do
    collection do
      get :for_admin_notify
    end
  end

  resources :member_account_bookings

  get 'member_report' => 'member_report#index'
  get 'member_report/by_lv' => 'member_report#by_lv'
  get 'member_report/report_sheet_stats' => 'member_report#report_sheet_stats'

  get 'home/member_data' => 'home#member_data'
  get 'home/reference_data' => 'home#reference_data'
  get 'home/admin_data' => 'home#admin_data'
  get 'home/landing_page' => 'home#landing_page'
  get 'home/magazine_data' => 'home#magazine_data'
  get 'home/festival_data' => 'home#festival_data'
  get 'home/cron' => 'home#cron'
  get 'home/tools' => 'home#tools'
  post 'home/export_view' => 'home#export_view'

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

    collection do 
        get :share_overview
    end


    resources :regional_organization_reports, :path => :reports do
      collection do
        get :members
        get :orch
        get :person
        get :oddset_report
        get :fee_shares
        get :index
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
    resources :reports do
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
  end
    resources :member_account_bookings, :shallow=>true do
      member do
        get 'download'
      end
    end

  end

  resources :tariffs


#confidential
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
  end
  # ORCHESTRA END

  # reports
  namespace :reports do
    resources :gema
    resources :member_account_bookings
    resources :new_members
  end

  # the admin  equivalent of the public entities
  resources :addresses

  resources :honor_members

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

    resources :countries do
      resources :states
    end

    resources :composers do

      collection do
          get :public
      end
    end

    resources :regional_organizations, :as => "lv" do
    end
  end # END NAMESPACE PUBLIC

  # MAGAZINE
  namespace :magazine do
    get 'address_list', to: 'address_list#index'
    resources :magazine_issues, :path => :issues, :as => :issues do
      resources :magazine_adverts, :path => :adverts, :as => :adverts, :shallow=>true do
        member do
          get :gen_advert_invoices
          get :counts
        end
      end
    end

    resources :advertisers

    resources :samplings, controller: 'magazine_samplings' do
      collection do
        get :print_list
      end
    end
  end
end
