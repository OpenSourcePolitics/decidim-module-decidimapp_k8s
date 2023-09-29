# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path = File.expand_path(File.join("spec", "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"
require "support/environment_variables_helper"

RSpec.configure do |c|
  c.include EnvironmentVariablesHelper

  Decidim.available_locales = %w(ca es en fr)
  I18n.available_locales = [:ca, :es, :en, :fr]
  I18n.default_locale = :en

  RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
end

def load_fixture!(filename = "configuration.yml")
  YAML.load_file(File.join(__dir__, "fixtures", filename)).deep_symbolize_keys
end
