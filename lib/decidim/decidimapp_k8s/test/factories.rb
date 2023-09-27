# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :decidimapp_k8s_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :decidimapp_k8s).i18n_name }
    manifest_name :decidimapp_k8s
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
