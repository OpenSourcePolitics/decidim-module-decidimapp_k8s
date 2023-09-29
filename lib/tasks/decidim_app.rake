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
      verbose = (ENV.fetch("v", nil).present? || ENV.fetch("verbose", nil).present?)
      log_path = ENV.fetch("log_path", "log/external_install_or_reload.log")

      raise ConfigurationError if path.blank?

      configuration = YAML.load_file(path).deep_symbolize_keys
      Decidim::DecidimappK8s::Manager.run(configuration, Decidim::LoggerWithStdout.new(log_path, verbose: verbose))
    rescue ConfigurationError => e
      puts e.message.red
      puts "Help:
  $ bundle exec rake decidim_app:k8s:external_install_or_reload path='path/to/external_install_configuration.yml' v=true".yellow
    rescue Errno::ENOENT => e
      puts e.message.red
      puts "Help: Given path does not exist, path='#{path}'".yellow
    end
  end
end
