require "rails"

module Approval
  class Engine < ::Rails::Engine
    initializer "approval.mixins" do
      Rails.application.reloader.to_prepare do
        ActiveSupport.on_load :active_record do
          extend ::Approval::Mixins
        end
      end
    end

    config.to_prepare do
      Approval.init!
    end
  end
end
