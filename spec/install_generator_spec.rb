require 'generator_spec'
require "generators/grape_resource/install_generator"

RSpec.describe GrapeResource::InstallGenerator, type: :generator do
  it "successfully run install generator" do
    run_generator
    expect(File).to exist("config/initializers/grape_resource.rb")
    `rm -rf config`
  end
end
