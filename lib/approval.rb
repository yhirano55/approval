module Approval
  def self.config
    @_config ||= Config.new
  end

  def self.configure
    yield config
  end

  def self.init!
    user_model = Approval.config.user_class_name.safe_constantize
    user_model.include ::Approval::Mixins::User if user_model
    [Approval::Request, Approval::Comment].each(&:define_user_association)
  end
end

require "approval/config"
require "approval/engine" if defined?(::Rails)
require "approval/version"
