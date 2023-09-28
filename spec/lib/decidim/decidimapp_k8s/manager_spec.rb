# frozen_string_literal: true

require "spec_helper"

describe Decidim::DecidimappK8s::Manager do
  subject { described_class.run(conf) }

  let(:conf) { load_fixture! }
  let(:admin_email) { conf[:system_admin][:email] }

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

  context "when system admin already exists" do
    before do
      create(:admin, email: admin_email)
    end

    it "does not create a system admin" do
      expect { subject }.not_to change(Decidim::System::Admin, :count)
    end

    it "does not raise an error" do
      expect { subject }.not_to raise_error
    end

    it "does not update the system admin" do
      expect { subject }.not_to change(Decidim::System::Admin, :first)
    end
  end
end
