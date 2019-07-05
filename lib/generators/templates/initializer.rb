GrapeResource.setup do |config|
  # Directory to create endpoint
  config.directory = "controllers/API/v1/"

  # Class name prefix
  config.class_name_prefix = "API::V1"

  # Entry point routes
  config.entry_point_routes = "# Routes entry point"

  # Formatter
  config.success_formatter = "formatter :json, ::API::SuccessFormatter"
  config.error_formatter = "error_formatter :json, ::API::ErrorFormatter"
end
