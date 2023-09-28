# frozen_string_literal: true

require "spec_helper"

describe Decidim::DecidimappK8s::Manager do
  subject { described_class }

  let(:conf) { load_fixture! }

  describe "Manager#run" do
    subject { described_class.run(conf) }

    it "creates a system admin" do
      expect { subject }.to change(Decidim::System::Admin, :count).by(1)
    end

    it "creates a new organization" do
      expect { subject }.to change(Decidim::Organization, :count).by(2)
    end

    it "creates a new admin for each organization" do
      subject

      expect(Decidim::Organization.all.map(&:admins).flatten.count).to eq(2)
      expect(Decidim::User.all.count).to eq(2)
    end
  end
end
