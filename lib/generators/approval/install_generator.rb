require "rails/generators"
require "rails/generators/active_record"

module Approval
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration
    source_root File.expand_path("templates", __dir__)

    class << self
      def next_migration_number(dirname)
        ::ActiveRecord::Generators::Base.next_migration_number(dirname)
      end
    end

    def create_migration_file
      add_migration_file("create_approval_requests")
      add_migration_file("create_approval_comments")
      add_migration_file("create_approval_items")
    end

    def create_initializer
      copy_file("initializer.rb", "config/initializers/approval.rb")
    end

    private

      def add_migration_file(template)
        migration_dir = File.expand_path("db/migrate")

        if self.class.migration_exists?(migration_dir, template)
          ::Kernel.warn "Migration already exists: #{template}"
        else
          migration_template("#{template}.rb.tt", "db/migrate/#{template}.rb", migration_version: migration_version)
        end
      end

      def migration_version
        major = ActiveRecord::VERSION::MAJOR

        if major >= 5
          "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
        end
      end
  end
end
