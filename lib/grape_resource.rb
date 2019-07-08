require "grape_resource/version"
require "grape_resource/configuration"

module GrapeResource
  class Error < StandardError; end
  
  extend GrapeResource::Configuration

  define_setting :directory, "controllers/API/v1/"
  define_setting :class_name_prefix, "API::V1"
  define_setting :entry_point_routes, "# Routes entry point"
  define_setting :success_formatter, "formatter :json, ::API::SuccessFormatter"
  define_setting :error_formatter, "error_formatter :json, ::API::ErrorFormatter"
end
