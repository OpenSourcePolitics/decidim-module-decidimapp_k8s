module Decidim
  module DecidimappK8s
    class Manager
      def initialize(conf)
        @conf = conf
      end

      def self.run(conf)
        new(conf).run
      end

      def run
        # Setup objects based on configuration
        # Create system admin
        # Create organizations
        # Create admins
        # Create users

        Decidim::System::Admin.create!(@conf[:system_admin])
      end
    end
  end
end