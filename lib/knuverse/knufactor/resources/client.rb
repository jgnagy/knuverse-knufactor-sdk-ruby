module KnuVerse
  module Knufactor
    module Resources
      # The Knufactor Client resource
      #   rubocop:disable Style/ExtraSpacing
      class Client < Resource
        property :bypass_expiration
        property :bypass_limit
        # @return [Boolean]
        # @!method bypass_require_code?
        property :bypass_require_code,    type: :boolean, read_only: true
        property :bypass_require_pin,     type: :boolean
        property :bypass_spacing_minutes
        property :client_id,                              id_property: true
        property :disable_clients_global, type: :boolean
        property :email_verified,         type: :boolean, read_only: true
        property :enroll_date,            type: :time,    read_only: true
        property :enroll_deadline_date,   type: :time
        property :enroll_deadline_remaining_minutes
        property :has_password,           type: :boolean, read_only: true
        property :has_pin,                type: :boolean, read_only: true
        property :has_verified,           type: :boolean, read_only: true
        property :help_tip,                               read_only: true
        property :is_disabled,            type: :boolean
        property :is_gauth,               type: :boolean, read_only: true
        property :is_tenant_client,       type: :boolean, read_only: true
        property :last_verification_date, type: :time,    read_only: true
        property :name,                                   read_only: true
        property :notification,                           read_only: true
        property :password,                               write_only: true
        property :password_lock,          type: :boolean
        property :phone_number_last,                      read_only: true
        property :pin_rev,                                read_only: true
        property :role
        property :role_rationale
        property :row_doubling
        property :state,                                  read_only: true
        property :verification_lock,      type: :boolean
        property :verification_speed
        property :verification_speed_floor,               read_only: true
      end
    end
  end
end
