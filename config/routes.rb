Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "admin/dashboard#index"

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    get "calendar", to: "calendar#index"

    # Organization Management
    resources :forums
    resources :chapters
    resources :regions
    resources :locations

    # User Management
    resources :members do
      member do
        patch :suspend
        patch :transfer
        patch :renew
        get :referral_history
        get :attendance_history
      end
    end
    resources :guests do
      member do
        patch :convert_to_member
      end
    end
    resources :users

    # Role & Permission Management
    resources :roles do
      member do
        post :clone
      end
    end
    resources :permissions, only: [:index, :update]
    resources :sidebar_accesses, only: [:index, :update]

    # Membership Management
    resources :membership_plans
    resources :membership_renewals
    resources :fee_collections

    # Business Directory
    resources :business_categories
    resources :business_specialties

    # Referral Management
    resources :referrals do
      member do
        patch :update_workflow
      end
      collection do
        get :given
        get :received
        get :pipeline
      end
    end

    # Business Generated
    resources :thank_you_slips

    # Networking Activities
    resources :one_to_ones
    resources :office_darshans

    # Meetings & Events
    resources :weekly_meetings do
      resources :meeting_attendances, only: [:index, :create, :update]
      resources :guest_attendances, only: [:index, :create, :update]
    end
    resources :events do
      resources :event_registrations, only: [:index, :create, :update, :destroy]
    end

    # Committee Management
    resources :committee_roles
    resources :committee_assignments

    # Communication
    resources :email_templates
    resources :sms_templates
    resources :whatsapp_templates
    resources :notifications

    # Reports
    get "reports", to: "reports#index"
    get "reports/members", to: "reports#members_report"
    get "reports/attendance", to: "reports#attendance_report"
    get "reports/referrals", to: "reports#referral_report"
    get "reports/revenue", to: "reports#revenue_report"
    get "reports/guest_conversion", to: "reports#guest_conversion_report"

    # Audit Logs
    resources :audit_logs, only: [:index]

    # Settings
    namespace :settings do
      get "general", to: "general#index", as: :general
      patch "general", to: "general#update"
      get "payment_gateway", to: "payment_gateway#index", as: :payment_gateway
      patch "payment_gateway", to: "payment_gateway#update"
      resources :attendance_rules
      resources :referral_rules
    end
  end
end
