module GrapeResource
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)

    def copy_initializer
      template "initializer.rb", "config/initializers/grape_resource.rb"
    end

    def insert_entry_point
      insert_into_file "app/#{GrapeResource.directory}/main.rb", "\n\n      #{GrapeResource.entry_point_routes} -- DONT REMOVE THIS LINE", after: "      mount API::V1::Info::Routes"
    end

  end
end