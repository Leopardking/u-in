BookingApp::Application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  get "/users/:id/add_email", to: "users#add_email", via: [:get, :patch, :post], as: :add_user_email
  get "/contact", to: "contact#index"
  post "/contact", to: "contact#send_contact"
  get "/contact_us_result", to: "contact#contact_us_result"
  get "/merchant_page", to: "home#merchant_page", as: :merchant_page

  post "promotions/:blackout_id/cancel_blackout", to: "promotions#cancel_blackout", as: :cancel_blackout
  get "/merchants/:merchant_id/business", to: "employees#business", as: :employees_business

  devise_for :users, path: :auth,
    controllers: {
      omniauth_callbacks: :omniauth_callbacks,
      registrations: :registrations,
      confirmations: :confirmations
    }

  devise_scope :user do
    get "/auth/change_password", to: "registrations#edit_password"
    post "/auth/new_profile", to: "registrations#new_profile"
    get "/auth/check_user_unique", to: "registrations#check_user_unique"
    get "/auth/confirmation_success", to: "registrations#comfirmation_success"
    get "/auth/billing_card", to: "registrations#billing_card"
    post "/auth/billing_card", to: "registrations#create_billing_card"
    get "/auth/index_regis", to: "registrations#index_regis"
    get "/auth/check_email_regis", to: "registrations#check_email_regis"
    get "/auth/account_regis", to: "registrations#account_regis"
    post "/auth/get_info_account", to: "registrations#get_info_account"
    get "/auth/:id/card", to: "registrations#card", as: :auth_card
    put "/auth/:id/card", to: "registrations#update_card"
    get "/auth/check_email_present", to: "sessions#check_email_present"
    get "/auth/index", to: "sessions#index"
    get "/auth/destroy", to: "sessions#destroy"
    post "/auth/create", to: "passwords#create", as: :reset_password
    post "/auth/create_billing_card_merchant", to: "registrations#create_billing_card_merchant"
    get "/auth/redirect", to: "sessions#redirect"

  end

  root 'home#index'

  resources :home, except: [:index] do
    collection do
      get 'check_password_page'
      get 'check_pass'
      get :privacy_policy
    end
  end
  # get '*path' => 'home#index'

  resources :users do
    collection do
      post "new_step2"
      post "crop_avatar"
    end
    member do
      get "delete_account"
      post "send_reset_password"
      get "business_address"
    end
  end
  resources :faqs do
    collection do
      get "search"
    end
  end

  resources :bookings do
    collection do
      post "create_new_booking"
      post "payment_booking_merchant"
      post "payment_booking_client"
    end
  end
  resources :images do
    collection do
      post "upload_image"
      post "upload_image_step3"
    end
  end

  resources :promotions do
    member do
      get "share"
      get "check_deletion"
      get "customer_contacts"
      post "set_cancel_reactive_status"
      get "reset_pricing"
      patch "update_pricing"
      post "apply_blackout"
      put :publish_promotion
    end
    collection do
      get "get_cus_email"
      get "add_image"
      post "upload_image"
      get "show_inactive"
      post "get_current_rank"
      get "get_blackout_details"
    end
  end

  resources :temp_promotions

  resources :calendars,only:[:index] do
    collection do
      get "get_promotion_for_blackout"
      get "get_events"
      get "get_segmented_events"
      get "export_to_google_calendar"
    end
  end
  resources :categories, except: [:show, :new] do
    member do
      get "delete"
    end
    collection do
      get "check_categories_unique"
    end
  end

  resources :activities do
    member do
      get "view_day"
      get "cus_month_calendars"
      get "data_day"
      get "booked"
      resources :reviews
      post "bookmark"
      get "remove_bookmark"
    end
    collection do
      post "book"
      get "genre"
      get "my_activity"
    end
  end
  resources :my_activities,only: [:destroy, :index] do
    member do
      get "contact", to: "my_activities#contact"
      post "contact", to: "my_activities#send_contact"
      get "destroy"
    end
    collection do
      post "cancel_booking"
    end
  end
  resources :history_v_moneys,only: [:index] do
  end
  # always the last routes
  match '*unmatched_route', :to => 'application#raise_not_found!', :via => :all
end
