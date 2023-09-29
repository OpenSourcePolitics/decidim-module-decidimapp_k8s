# frozen_string_literal: true

module Decidim
  module DecidimappK8s
    class Manager
      attr_accessor :logger

      def initialize(conf, logger = Rails.logger)
        @conf = conf
        @logger = logger
      end

      def self.run(conf, logger = Rails.logger)
        new(conf, logger).run
      end

      def run
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
          existing_admin.name = params[:name]
          existing_admin.nickname = params[:nickname]
          existing_admin.validate! # Raises ActiveRecord::RecordInvalid if validations fail else returns true

          log!(:warn, "topic:admin action:update - #{existing_admin.email} already exists for organization '#{organization.name}'. Updating.")
          # rubocop:disable Rails/SkipsModelValidations
          existing_admin.update_columns(
            name: params[:name],
            nickname: params[:nickname]
          )
          # rubocop:enable Rails/SkipsModelValidations
        else
          log!(:info, "topic:admin action:create - #{admin.email} does not exist for organization '#{organization.name}'. Creating.")
          admin.save!
        end
      rescue StandardError => e
        log!(:error, "topic:admin action:create - #{admin.email} could not be created. #{e.message}")
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
        org = (Decidim::Organization.find_by(host: organization[:host]) || Decidim::Organization.find_by(name: organization[:name]))
        if org.present?
          log!(:warn, "topic:organization action:update - 'name: #{org.name}' already exists. Updating.")
          org.assign_attributes(organization)
          return org.save! if org.valid?

          log!(:error, "topic:organization action:update - 'host: #{organization[:host]}' could not be updated. (ERROR: #{org.errors.full_messages.join(", ")})")
        else
          log!(:info, "topic:organization action:create - 'host: #{organization[:host]}' does not exist. Creating.")
          org = Decidim::Organization.new(organization)

          return org.save! if org.valid?

          log!(:error, "topic:organization action:create - 'host: #{organization[:host]}' could not be created. (ERROR: #{org.errors.full_messages.join(", ")})")
        end
      rescue StandardError => e
        log!(:error, "topic:organization action:create - 'host: #{organization[:host]}' could not be created. (ERROR: #{e.message})")
      end

      # Create a new Decidim::System::Admin only if email does not already exists
      # @return Decidim::System::Admin || nil
      # TODO: System admin can't be updated
      def create_system_admin_if_not_exists
        admin = Decidim::System::Admin.find_by(email: @conf.dig(:system_admin, :email))
        if admin.present?
          log!(:warn, "topic:system_admin action:create - #{admin.email} already exists. Skipping creation.")
          return admin
        end

        create_system_admin!
      end

      def create_system_admin!
        system_admin = Decidim::System::Admin.create!(@conf[:system_admin])
        log!(:info, "topic:system_admin action:create - '#{system_admin.email}' created successfully.")
      rescue StandardError => e
        log!(:warning, "topic:system_admin action:create - #{e.message}")
      end

      def log!(level, message)
        message = case level
                  when :info
                    message.green
                  when :warn
                    message.yellow
                  when :error
                    message.red
                  else
                    message.reset
                  end

        @logger.send(level, message) if @logger.present?
      end
    end
  end
end
