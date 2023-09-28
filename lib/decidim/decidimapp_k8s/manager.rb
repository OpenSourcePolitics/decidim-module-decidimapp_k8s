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
          create_or_update_admin_for(org)
        end
      rescue StandardError => e
        puts e.message
      end

      def create_or_update_admin_for(organization)
        admin = new_user_for(organization)
        existing_admin = organization.admins.find_by(email: admin.email)

        # If the admin exists, update it with the new values
        if existing_admin.present?
          # In User model searchable_fields callback is failing and not allowing to update the admin
          # For now, we are updating the admin directly in the database using update_columns
          # update_columns does not allow to update the password, so we are excluding it from the params
          params = @conf[:default_admin].except(:password)
          existing_admin.update_columns(params)
        else
          admin.save!
        end
      end

      def new_user_for(org)
        Decidim::User.new(@conf[:default_admin].merge({
                                                        organization: org,
                                                        admin: true,
                                                        tos_agreement: true,
                                                        password_confirmation: @conf.dig(:default_admin, :password),
                                                        newsletter_notifications_at: Time.zone.now,
                                                        admin_terms_accepted_at: Time.zone.now,
                                                        confirmed_at: Time.zone.now
                                                      }))
      end

      def create_or_update_organization(organization)
        org = Decidim::Organization.find_by(host: organization[:host])
        if org.present?
          org.update!(organization)
        else
          Decidim::Organization.create!(organization)
        end
      rescue StandardError
        nil
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
