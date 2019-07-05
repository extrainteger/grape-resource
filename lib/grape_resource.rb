require "grape_resource/version"
require "grape_resource/configuration"

module GrapeResource
  class Error < StandardError; end
  
  extend GrapeResource::Configuration

  define_setting :directory, "controllers/API/v1/"
  define_setting :class_name_prefix, "API::V1"
  define_setting :entry_point_routes, "# Routes entry point"
end
