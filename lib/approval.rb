module Approval
  def self.config
    @_config ||= Config.new
  end

  def self.configure
    yield config
  end

  def self.init!
    Approval.config.user_class_name.constantize.include ::Approval::Mixins::User
    [Approval::Request, Approval::Comment].each(&:define_user_association)
  end
end

require "approval/config"
require "approval/engine" if defined?(::Rails)
require "approval/version"
