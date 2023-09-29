# frozen_string_literal: true

require "spec_helper"

describe "rake decidim_app:k8s:external_install_or_reload", type: :task do
  let(:path) { "spec/fixtures/configuration.yml" }
  let(:log_path) { "spec/decidim_dummy_app/log/test.log" }

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "calls the manager service" do
    with_modified_env path: path, log_path: log_path do
      expect(Decidim::DecidimappK8s::Manager).to receive(:run).once
      task.execute
    end
  end

  context "when path is not specified" do
    it "does not call Manager" do
      with_modified_env path: nil do
        expect(Decidim::DecidimappK8s::Manager).not_to receive(:run)
      end
    end
  end

  context "when path is specified but file does not exist" do
    it "does not call Manager" do
      with_modified_env path: "dummy_path" do
        expect(Decidim::DecidimappK8s::Manager).not_to receive(:run)
      end
    end
  end
end
