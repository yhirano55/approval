module Approval
  class Engine < ::Rails::Engine
    paths["app/models"] << "lib/approval/models"

    initializer "approval" do
      ActiveSupport.on_load :active_record do
        require "approval/mixins"
        ActiveRecord::Base.send :include, ::Approval::Mixins
      end
    end
  end
end
