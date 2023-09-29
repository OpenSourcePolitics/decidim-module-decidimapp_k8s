# frozen_string_literal: true

require "decidim/decidimapp_k8s/manager"

class ConfigurationError < StandardError
  def initialize(msg = "You must specify a path to an external install configuration, path='path/to/external_install_configuration.yml'")
    super
  end
end

namespace :decidim_app do
  namespace :k8s do
    desc "Create install or reload install with path='path/to/external_install_configuration.yml'"
    task external_install_or_reload: :environment do
      path = ENV.fetch("path", nil)
      raise ConfigurationError if path.blank?

      configuration = YAML.load_file(path).deep_symbolize_keys
      Decidim::DecidimappK8s::Manager.run(configuration, Logger.new($stdout))
    rescue ConfigurationError => e
      puts e.message.red
      puts "Example:
$ bundle exec rake decidim_app:k8s:external_install_or_reload path='path/to/external_install_configuration.yml'".yellow
    rescue Errno::ENOENT => e
      puts e.message.red
      puts "Given path does not exist, path='#{path}'".yellow
    end
  end
end
