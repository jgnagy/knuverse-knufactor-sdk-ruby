module KnuVerse
  module Knufactor
    module Resources
      # The Knufactor Client resource
      #   rubocop:disable Style/ExtraSpacing
      #   rubocop:disable Metrics/LineLength
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
        property :has_verified,           type: :boolean, read_only: true,  as: :verified
        property :help_tip,                               read_only: true
        property :is_disabled,            type: :boolean,                   as: :disabled
        property :is_gauth,               type: :boolean, read_only: true,  as: :gauth
        property :is_tenant_client,       type: :boolean, read_only: true,  as: :tenant_client
        property :last_verification_date, type: :time,    read_only: true
        property :name,                                   read_only: true
        property :notification,                           read_only: true
        property :password,                               write_only: true
        property :password_lock,          type: :boolean,                   as: :password_locked, validate: true
        property :phone_number_last,                      read_only: true
        property :pin_rev,                                read_only: true
        property :role
        property :role_rationale
        property :row_doubling
        property :state,                                  read_only: true
        property :verification_lock,      type: :boolean,                   as: :verification_locked, validate: true
        property :verification_speed
        property :verification_speed_floor,               read_only: true

        private

        # Used to validate {#password_lock} on set
        def validate_password_lock(value)
          value == false # only `false` is valid
        end

        # Used to validate {#password_lock} on set
        def validate_verification_lock(value)
          value == false # only `false` is valid
        end
      end
    end
  end
end
