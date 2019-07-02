module API
  module V1
    module <%= name.capitalize %>
      class Routes < Grape::API
        # Format response
        formatter :json, ::API::SuccessFormatter
        error_formatter :json, ::API::ErrorFormatter

        mount <%= GrapeResource.class_name_prefix %>::<%= name.capitalize %>::Resources::<%= name.capitalize %>
      end
    end
  end
end
