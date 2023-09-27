# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module DecidimappK8s
    # This is the engine that runs on the public interface of decidimapp_k8s.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::DecidimappK8s
    end
  end
end
