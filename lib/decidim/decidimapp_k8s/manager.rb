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

        @conf[:organizations].each do |org|
          Decidim::Organization.create!(org)
        end

        Decidim::Organization.all.each do |org|
          Decidim::User.create!(@conf[:default_admin].merge({
                                                              organization: org,
                                                              admin: true,
                                                              tos_agreement: true,
                                                              password_confirmation: @conf.dig(:default_admin, :password),
                                                              newsletter_notifications_at: Time.zone.now,
                                                              admin_terms_accepted_at: Time.zone.now,
                                                              confirmed_at: Time.zone.now }))
        end
      end
    end
  end
end