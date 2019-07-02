require "generators/grape_resource/generator_helpers.rb"

module GrapeResource
  class NamespaceGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../../templates", __FILE__)
    include GrapeResource::GeneratorHelpers

    def insert_resources
      check_endpoint_or_method args
      @entities = editable_attributes.map { |column| [column.name, column.type] }
      template "resources.rb.erb", "app/#{GrapeResource.directory}/#{name.downcase.singularize}/resources/#{name.downcase.singularize}.rb"
      insert_into_file "app/#{GrapeResource.directory}/main.rb", "\n      mount API::V1::#{name.capitalize.singularize}::Routes", after: "mount API::V1::Info::Routes"
      inside "app/#{GrapeResource.directory}/#{name.downcase.singularize}/resources/" do
        gsub_file("#{name.downcase.singularize}.rb", /.*?remove.*\r?\n/, "")
      end
    end

    def insert_entities
      @entities = editable_attributes.map { |column| column.name }
      template "entities.rb.erb", "app/#{GrapeResource.directory}/#{name.downcase.singularize}/entities/#{name.downcase.singularize}.rb"
      inside "app/#{GrapeResource.directory}/#{name.downcase.singularize}/entities/" do
        gsub_file("#{name.downcase.singularize}.rb", /.*?remove.*\r?\n/, "")
      end
    end

    def insert_spec
      template "specs.rb", "app/#{GrapeResource.directory}/#{name.downcase}/spec/#{name.downcase.singularize}_spec.rb"
    end

    def insert_resource_router
      template "routes.rb", "app/#{GrapeResource.directory}/#{name.downcase}/routes.rb"
    end

  end
end
