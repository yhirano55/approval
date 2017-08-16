module Approval
  class Engine < ::Rails::Engine
    paths["app/models"] << "lib/approval/models"

    initializer "approval" do
      ActiveSupport.on_load :active_record do
        require "approval/mixins"
        ActiveRecord::Base.include ::Approval::Mixins
      end
    end

    config.to_prepare do
      Approval.init!
    end
  end
end
