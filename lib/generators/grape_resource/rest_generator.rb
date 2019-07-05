require "generators/grape_resource/generator_helpers.rb"

module GrapeResource
  class RestGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../../templates", __FILE__)
    include GrapeResource::GeneratorHelpers

    def run_me
      unless Object.const_defined?(name.classify)
        say
        say
        say "You need to generate model", :red
        say
        say "Example :"
        say "  rails g model #{name.classify} attr1 attr2", :green
        say
        return
      end

      create_rest_endpoint
      insert_rest_entities
      insert_spec
      insert_rest_routes
    end

    private

    def create_rest_endpoint
      attributes_for_params

      template "rest/rest_endpoint.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/resources/#{name.underscore.pluralize}.rb"

      insert_into_file "app/#{GrapeResource.directory}/main.rb", "\n      mount API::V1::#{name.camelize.pluralize}::Routes", after: "mount API::V1::Info::Routes"

      # insert_into_file "app/#{GrapeResource.directory}/helpers.rb", "\n\n  def permitted_params\n    @permitted_params ||= declared(params, include_missing: false)\n  end", after: "  end"
      
      inside "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/resources/" do
        gsub_file("#{name.underscore.pluralize}.rb", /.*?remove.*\r?\n/, "")
      end
    end

    def insert_rest_entities
      attributes_for_params

      template "rest/entities.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/entities/#{name.underscore.pluralize}.rb"

      inside "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/entities/" do
        gsub_file("#{name.underscore.pluralize}.rb", /.*?remove.*\r?\n/, "")
      end
    end

    def insert_spec
      template "rest/specs.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/spec/#{name.underscore.pluralize}_spec.rb"
    end

    def insert_rest_routes
      template "rest/routes.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/routes.rb"
    end
  end
end
