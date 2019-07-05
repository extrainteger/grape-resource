GrapeResource.setup do |config|
  # Directory to create endpoint
  config.directory = "controllers/API/v1/"

  # Class name prefix
  config.class_name_prefix = "API::V1"

  # Entry point routes
  config.entry_point_routes = "# Routes entry point"
end