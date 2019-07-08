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

      generator_type "rest"
      create_rest_endpoint
      insert_into_main unless mounted_routes_exist?
      insert_rest_entities unless entities_exist?
      template_rspec unless rspec_exist?
      routes_exist? ? insert_rest_routes : template_rest_routes
    end

    private
      def create_rest_endpoint
        attributes_for_params

        template "rest/rest_endpoint.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/resources/#{name.underscore.pluralize}.rb"

        inside "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/resources/" do
          gsub_file("#{name.underscore.pluralize}.rb", /.*?remove.*\r?\n/, "")
        end
      end

      def insert_into_main
        insert_into_file "app/#{GrapeResource.directory}/main.rb", "      mount API::V1::#{name.camelize.pluralize}::Routes\n", before: "      #{GrapeResource.entry_point_routes} -- DONT REMOVE THIS LINE"
      end

      def insert_rest_entities
        attributes_for_params

        template "entities.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/entities/#{name.underscore.singularize}.rb"

        inside "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/entities/" do
          gsub_file("#{name.underscore.singularize}.rb", /.*?remove.*\r?\n/, "")
        end
      end

      def template_rspec
        template "specs.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/spec/#{name.underscore.pluralize}_spec.rb"
      end

      def insert_rest_routes
        insert_into_file "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/routes.rb", "        mount #{GrapeResource.class_name_prefix}::#{name.camelize.pluralize}::Resources::#{name.camelize.pluralize}\n", before: "        #{GrapeResource.entry_point_routes} -- DONT REMOVE THIS LINE\n" unless mount_code_exist?
      end
      
      def template_rest_routes
        template "routes.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/routes.rb"
      end

  end
end
