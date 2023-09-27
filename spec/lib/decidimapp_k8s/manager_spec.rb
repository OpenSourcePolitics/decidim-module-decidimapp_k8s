require "spec_helper"

describe Decidim::DecidimappK8s::Manager do
  subject { described_class }

  let(:conf) { load_fixture! }

  describe "Manager#run" do
    subject { described_class.run(conf) }

    it "returns a string" do
      expect { subject }.to change(Decidim::System::Admin, :count).by(1)
    end
  end
end
