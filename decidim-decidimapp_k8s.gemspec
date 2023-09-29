# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/decidimapp_k8s/version"

Gem::Specification.new do |s|
  s.version = Decidim::DecidimappK8s.version
  s.authors = ["quentinchampenois"]
  s.email = ["26109239+Quentinchampenois@users.noreply.github.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-decidimapp_k8s"
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-decidimapp_k8s"
  s.summary = "A decidim decidimapp_k8s module"
  s.description = "Manage DecidimApp application to run on Kubernetes cluster."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::DecidimappK8s.decidim_version
  s.add_dependency "decidim-system", Decidim::DecidimappK8s.decidim_version
  s.add_development_dependency "climate_control", "~> 1.2"
  s.add_development_dependency "decidim-dev", Decidim::DecidimappK8s.decidim_version
end
