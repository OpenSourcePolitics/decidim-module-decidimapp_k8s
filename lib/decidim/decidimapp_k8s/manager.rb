# frozen_string_literal: true

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

        create_system_admin_if_not_exists

        @conf[:organizations].each do |org|
          create_or_update_organization(org)
        end

        Decidim::Organization.all.each do |org|
          Decidim::User.create!(@conf[:default_admin].merge({
                                                              organization: org,
                                                              admin: true,
                                                              tos_agreement: true,
                                                              password_confirmation: @conf.dig(:default_admin, :password),
                                                              newsletter_notifications_at: Time.zone.now,
                                                              admin_terms_accepted_at: Time.zone.now,
                                                              confirmed_at: Time.zone.now
                                                            }))
        end
      rescue StandardError => e
        puts e.message
      end

      def create_or_update_organization(organization)
        org = Decidim::Organization.find_by(host: organization[:host])
        if org.present?
          org.update!(organization)
        else
          Decidim::Organization.create!(organization)
        end
      end

      # Create a new Decidim::System::Admin only if email does not already exists
      # @return Decidim::System::Admin || nil
      # TODO: System admin can't be updated
      def create_system_admin_if_not_exists
        admin = Decidim::System::Admin.find_by(email: @conf.dig(:system_admin, :email))
        return admin if admin.present?

        create_system_admin!
      end

      def create_system_admin!
        Decidim::System::Admin.create!(@conf[:system_admin])
      rescue StandardError => e
        puts e.message
      end
    end
  end
end
