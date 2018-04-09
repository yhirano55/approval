module Approval
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def create_migration_file
      rake "approval_engine:install:migrations"
    end

    def create_initializer
      copy_file "initializer.rb.tt", "config/initializers/approval.rb"
    end
  end
end
