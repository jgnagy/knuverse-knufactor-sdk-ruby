# Standard Library Requirements
require 'json'
require 'singleton'

# External Library Requirements
require 'linguistics'
Linguistics.use(:en)
require 'rest-client'
require 'will_paginate'
require 'will_paginate/array'

# Internal Requirements
require 'core_extensions/string/transformations'
String.include CoreExtensions::String::Transformations

require 'knuverse/knufactor/version'
require 'knuverse/knufactor/api_exception'
require 'knuverse/knufactor/exceptions/api_client_not_configured'
require 'knuverse/knufactor/exceptions/immutable_modification'
require 'knuverse/knufactor/exceptions/invalid_arguments'
require 'knuverse/knufactor/exceptions/invalid_options'
require 'knuverse/knufactor/exceptions/invalid_property'
require 'knuverse/knufactor/exceptions/invalid_where_query'
require 'knuverse/knufactor/exceptions/missing_path'
require 'knuverse/knufactor/exceptions/new_instance_with_id'
require 'knuverse/knufactor/helpers/api_client'
require 'knuverse/knufactor/validations/api_client'
require 'knuverse/knufactor/api_client_base'
require 'knuverse/knufactor/api_client'
require 'knuverse/knufactor/simple_api_client'
require 'knuverse/knufactor/resource_collection'
require 'knuverse/knufactor/helpers/resource'
require 'knuverse/knufactor/helpers/resource_class'
require 'knuverse/knufactor/validations/resource'
require 'knuverse/knufactor/resource'
require 'knuverse/knufactor/resources/client'

module KnuVerse
  # The SDK for interacting with the KnuVerse Knufactor Cloud API
  module Knufactor
  end
end
