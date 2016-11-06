# Standard Library Requirements
require 'json'
require 'singleton'

# External Library Requirements
require 'rest-client'
require 'will_paginate'
require 'will_paginate/array'

# Internal Requirements
require 'knuverse/knufactor/version'
require 'knuverse/knufactor/api_exception'
require 'knuverse/knufactor/exceptions/api_client_not_configured'
require 'knuverse/knufactor/exceptions/invalid_arguments'
require 'knuverse/knufactor/exceptions/invalid_options'
require 'knuverse/knufactor/api_client_helpers'
require 'knuverse/knufactor/api_client_validations'
require 'knuverse/knufactor/api_client_base'
require 'knuverse/knufactor/api_client'
require 'knuverse/knufactor/simple_api_client'

module KnuVerse
  # The SDK for interacting with the KnuVerse Knufactor Cloud API
  module Knufactor
  end
end
