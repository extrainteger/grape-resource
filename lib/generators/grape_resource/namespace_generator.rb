require "generators/grape_resource/generator_helpers.rb"

module GrapeResource
  class NamespaceGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../../templates", __FILE__)
    include GrapeResource::GeneratorHelpers

    def generate
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

      # insert_resources
      # insert_entities
      # insert_spec
      routes_exist? ? insert_rest_routes : template_rest_routes
    end

    private
      def insert_resources
        check_endpoint_or_method args
        attributes_for_params

        template "namespace/namespace_endpoint.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.singularize}/resources/#{name.underscore.singularize}.rb"

        insert_into_file "app/#{GrapeResource.directory}/main.rb", "      mount API::V1::#{name.camelize.singularize}::Routes\n", before: "      #{GrapeResource.entry_point_routes} -- DONT REMOVE THIS LINE"

        inside "app/#{GrapeResource.directory}/#{name.underscore.singularize}/resources/" do
          gsub_file("#{name.underscore.singularize}.rb", /.*?remove.*\r?\n/, "")
        end
      end

      def insert_entities
        attributes_for_params

        template "namespace/entities.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.singularize}/entities/#{name.underscore.singularize}.rb"

        inside "app/#{GrapeResource.directory}/#{name.underscore.singularize}/entities/" do
          gsub_file("#{name.underscore.singularize}.rb", /.*?remove.*\r?\n/, "")
        end
      end

      def insert_spec
        template "namespace/specs.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.singularize}/spec/#{name.underscore.singularize}_spec.rb"
      end

      def insert_rest_routes
        insert_into_file "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/routes.rb", "        mount #{GrapeResource.class_name_prefix}::#{name.camelize.pluralize}::Resources::#{name.camelize.singularize}\n", before: "        #{GrapeResource.entry_point_routes} -- DONT REMOVE THIS LINE\n" unless mount_code_exist? "namespace"
      end
      
      def template_rest_routes
        template "routes.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/routes.rb"

        insert_into_file "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/routes.rb", "        mount #{GrapeResource.class_name_prefix}::#{name.camelize.pluralize}::Resources::#{name.camelize.singularize}\n        #{GrapeResource.entry_point_routes} -- DONT REMOVE THIS LINE\n", before: "      end"
      end

  end
end
