# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
require "sidekiq/web"
require "sidekiq/cron/web"

hosts = {
  development: "admin-dev.zupfmusiker.de",
  production: "admin.zupfmusiker.de"
}.freeze

Rails.application.routes.default_url_options[:host] = hosts[Rails.env.to_sym]

Rails.application.routes.draw do
  resources :festival_exhibitors do
        member do
          get :invoice_preview
          get :gen_invoice
        end
  end
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount ActionCable.server => "/cable"


  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :gema_events
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # custom errors
  match "/403", to: "errors#forbidden", via: :all
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  match "/errors/403", to: "errors#access_denied", via: :all
  match "/errors/404", to: "errors#not_found", via: :all
  match "/errors/406", to: "errors#not_acceptable", via: :all
  match "/errors/500", to: "errors#internal_server_error", via: :all

  # test for exception notification via Mail
  get "test_exception_notifier" => "application#test_exception_notifier"

  # Start page
  root to: "home#landing_page"

  # login and logout urls ...
  as :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    get "users/edit" => "devise/registrations#edit", :as => "edit_user_registration"
    put "users" => "devise/registrations/update", :as => "user_registration"
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web, at: "/sidekiq"
    mount CorikaInvoices::Engine, at: "/invoice_engine", as: "invoice_engine"
  end

  mount CorikaSumup::Engine, at: "/sumup", as: "sumup_engine"

  resources :gema_events do
    collection do
      post :import
    end
  end


  get "/auth/:provider/callback", to: "sessions#create"

  resources :orchestra_members do
    collection do
      post :search
    end
    member do
      get "exchange"
    end
  end

  resources :festival_exhibitors

  resources :festival_concerts do
    member do
      get :programme
    end
    collection do
      get :overview
    end
  end

  resources :contact_events

  resources :feature_requests do
    collection do
      get :open
    end
  end

  # resources :mgl, :controller => "member_area"
  # TODO: Clarify scoping
  # devise_scope [:member,:user] do
  # authenticated do
  # BEGIN member namespace
  namespace :mgl do
    get 'sign_in', to: 'sessions#new'

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
        post "upload"
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
      get :no_tickets
      get :no_meals
      get :participant_overview
      get :gen_participant_sheets
      get :open_issues
    end
    member do
      get :gen_participant_sheet
      get :ticket_invoice
      get :ticket_invoice_preview
      get :fee_invoice
      get :fee_invoice_preview
    end

    resources :festival_pieces
    resources :festival_application_attachments
    resources :event_meals, as: :meals
  end

  resources :event_cards, param: :checkout_reference do
    member do
      get :gen_invoice
      get :pickup
      get :invoice_preview
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

  get "magazine_reports/calendar" => "magazine_reports#calendar"
  get "magazine_reports/counts" => "magazine_reports#counts"

  get "api/rsm/gen_data" => "report_sheet_mailings#gen_data"
  get "api/rsm/gen_mailings" => "report_sheet_mailings#gen_mailings"
  get "api/rsm/test" => "report_sheet_mailings#test"


  # Invoice generation checks
  get "/adm/invoice_check" => "adm/invoice_check#index"
  get "/adm/invoice_check/distinction" => "adm/invoice_check#distinction"
  get "/adm/invoice_check/orchestra" => "adm/invoice_check#orchestra"
  get "/adm/invoice_check/person_member" => "adm/invoice_check#person_member"
  get "/adm/mail_check/admin" => "adm/mail_check#admin_notify"

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

  devise_for :users, skip: [ :registrations ]
  devise_for :members, controllers: { registrations: "registrations" }, path_prefix: "mem"

  resources :users, path: :accounts do
    collection do
      get :for_admin_notify
    end
    member do
      post :add_role
    end
  end

  resources :member_account_bookings do
    member do
      get :invoice_preview
      get :invoice_sepa
    end
  end

  get "member_report" => "member_report#index"
  get "member_report/by_lv" => "member_report#by_lv"
  get "member_report/report_sheet_stats" => "member_report#report_sheet_stats"

  get "home/landing_page" => "home#landing_page"
  get "home/cron" => "home#cron"
  get "home/tools" => "home#tools"
  post "home/export_view" => "home#export_view"

  get "modify_pdf" => "modify_pdf#index"

  get "about" => "about#index"
  get "config" => "about#settings"

  get "custom_info_mail" => "custom_info_mail#index"
  get "custom_info_mail/test" => "custom_info_mail#test"
  post "custom_info_mail/send_mail" => "custom_info_mail#send_mail"
  get "custom_info_mail/template_test" => "custom_info_mail#template_test"

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
  resources :board_contacts

  resources :regional_organizations do
    collection do
      get :share_overview
    end

    resources :regional_organization_reports, path: :reports do
      collection do
        get :members
        get :orchestras
        get :person_members
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

    resources :report_sheets do
      member do
        get :invoice_preview
      end
    end
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

      resources :regional_organization_bookings, shallow: true do
        member do
          get "download"
        end
      end
    end
    resources :member_account_bookings, shallow: true do
      member do
        get "download"
      end
    end
  end

  resources :tariffs

  # confidential
  resources :report_sheets do
    collection do
      get "payed"
      get "final"
      get "not_final"
      get "analysis"
    end
    member do
      get "gen_pdf"
      get "invoice_preview"
    end
  end

  resources :person_members do
    resources :member_events do
      member do
        get "download"
      end
    end

    resources :member_account_bookings do
      member do
        get "download"
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
    member do
      get :invoice_preview
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
      get :invoice_preview
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
        get "download"
      end
    end

    resources :member_events do
      member do
        get "download"
      end
    end

    resources :orchestra_members do
      collection do
        get "delete_all"
        post :exchange_all
        get "check_double"
        get "upload_report"
        post "upload"
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
        get :invoice_preview
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
    post "invoices/gen_all" => "invoices#gen_all"
    post "invoices/gen_orchestras" => "invoices#gen_orchestras"
    post "invoices/gen_persons" => "invoices#gen_persons"
    post "get invoices/gen_lorch" => "invoices#gen_lorch"
    post "invoices/ping" => "invoices#ping"
    post "lv_fee_bookings/index" => "lv_fee_bookings#index"
    post "reminders/report_sheet" => "reminders#report_sheet"
    post "reminders/payment" => "reminders#payment"
    post "cancellations" => "batch#cancellations"

    post "cleanup/remove_resigned" => "cleanup#remove_resigned"

    # TODO: These aren't resources!
    resources :mails
    resources :downloads  do
      member do
        get :combined_invoice_pdf
      end
    end
  end

  get "dl/:year/:filename", to: "downloads#show", as: "dl"

  scope format: false do
    get "downloads/invoices/:generator_session_id/letters" => "downloads#combined_letters_pdf", as: "dl_invoice_letters"
    get "downloads/invoices/:generator_session_id/sepa" => "downloads#combined_sepa_pdf", as: "dl_sepa_invoices"
    get "downloads/sepa/:generator_session_id" => "downloads#combined_sepa_xml", as: "dl_sepa"
  end

  get "member_tools/kto_blz_to_iban_bic" => "member_tools#kto_blz_to_iban"
  get "member_tools/iban_calculator" => "member_tools#iban_calculator"
  get "home/index"

  get "reports/youth_addresses", to: "reports/youth_addresses#index", defaults: { format: "ods" }

  namespace :adm do
    resources :letter_file_regeneration
    resources :pdf_test do
      member do
        get :report_sheet_reminder
      end
    end
    resources :sepa_regeneration do
      collection do
        post :regenerate
        post :regenerate_by_date_and_type
      end
    end
    resources :member_account_bookings
  end

  # BEGIN EF Namespace

  namespace :ef do
    resources :timetables do
      collection do
        get :stage_times
      end
    end
    resources :festival_applications, param: :token do
      member do
        get :step2
        get :finalize
        get :fee_invoice
        get :ticket_invoice
        get :edit_tickets
        patch :update_tickets
      end
      collection do
        get :closed
      end
      resources :festival_pieces

      resources :event_meals do
        collection do
          get :order_form
          post :order_success
        end
      end
    end

    resources :event_cards, param: :checkout_reference do
      collection do
        get :order_form
        post :order
        get :invalid_state
      end
      member do
       get :choose_payment
       patch :payment
       get :payment_complete
       post :order_success
       post :order
       patch :confirm_dd_payment
      end
    end

  end

  # BEGIN public namespace
  namespace :public do
    resources :regional_organizations, as: "lv" do
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

    resources :contacts

    resources :countries do
      resources :states
    end

    resources :composers do
      collection do
        get :public
      end
    end

    resources :regional_organizations, as: "lv" do
    end
  end

  # MAGAZINE
  namespace :magazine do
    get "address_list", to: "address_list#index"
    resources :magazine_issues, path: :issues, as: :issues do
      resources :magazine_adverts, path: :adverts, as: :adverts, shallow: true do
        member do
          get :gen_advert_invoices
          get :counts
        end
      end
    end

    resources :advertisers

    resources :samplings, controller: "magazine_samplings" do
      collection do
        get :print_list
      end
    end
  end
end
