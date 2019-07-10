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

      generator_type "namespace"
      insert_resources
      insert_into_main unless mounted_routes_exist?
      insert_namespace_entities unless entities_exist?
      template_rspec
      routes_exist? ? insert_namespace_routes : template_namespace_routes
    end

    private
      def insert_resources
        check_endpoint_or_method args
        attributes_for_params

        template "namespace/namespace_endpoint.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/resources/#{name.underscore.singularize}.rb"

        inside "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/resources/" do
          gsub_file("#{name.underscore.singularize}.rb", /.*?remove.*\r?\n/, "")
        end
      end

      def insert_into_main
        insert_into_file "app/#{GrapeResource.directory}/main.rb", "      mount API::V1::#{name.camelize.pluralize}::Routes\n", before: "      #{GrapeResource.entry_point_routes} -- DONT REMOVE THIS LINE"
      end

      def insert_namespace_entities
        attributes_for_params

        template "entities.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/entities/#{name.underscore.singularize}.rb"

        inside "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/entities/" do
          gsub_file("#{name.underscore.singularize}.rb", /.*?remove.*\r?\n/, "")
        end
      end

      def template_rspec
        check_endpoint_or_method args
        template "namespace/specs.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/spec/#{name.underscore.singularize}_spec.rb"

        inside "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/spec/" do
          gsub_file("#{name.underscore.singularize}_spec.rb", /.*?remove.*\r?\n/, "")
        end
      end

      def insert_namespace_routes
        insert_into_file "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/routes.rb", "        mount #{GrapeResource.class_name_prefix}::#{name.camelize.pluralize}::Resources::#{name.camelize.singularize}\n", before: "        #{GrapeResource.entry_point_routes} -- DONT REMOVE THIS LINE\n" unless mount_code_exist?
      end
      
      def template_namespace_routes
        template "routes.rb.erb", "app/#{GrapeResource.directory}/#{name.underscore.pluralize}/routes.rb"
      end

  end
end
