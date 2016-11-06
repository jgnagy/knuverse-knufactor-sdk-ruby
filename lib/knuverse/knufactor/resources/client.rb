module KnuVerse
  module Knufactor
    module Resources
      # The Knufactor Client resource
      class Client < Resource
        property :bypass_enabled, type: :boolean
        property :bypass_expiration
        property :bypass_limit
        property :bypass_require_code, type: :boolean, read_only: true
        property :bypass_require_pin, type: :boolean
        property :bypass_spacing_minutes
        property :client_id, id_property: true
        property :disable_clients_global, type: :boolean
        property :email_verified, type: :boolean, read_only: true
        property :enroll_date, type: :time, read_only: true
        property :enroll_deadline_date, type: :time
        property :enroll_deadline_remaining_minutes
        property :has_password, type: :boolean, read_only: true
        property :has_pin, type: :boolean, read_only: true
        property :has_verified, type: :boolean, read_only: true
        property :help_tip, read_only: true
        property :is_disabled, type: :boolean
        property :is_gauth, type: :boolean
        property :is_tenant_client, type: :boolean, read_only: true
        property :last_verification_date, type: :time, read_only: true
        property :name
        property :notification, read_only: true
        property :password_lock, type: :boolean
        property :state, read_only: true

        path :all, 'clients'
      end
    end
  end
end
