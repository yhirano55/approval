module Approval
  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  def self.init!
    user_model = Approval.config.user_class_name.safe_constantize

    if user_model
      ::Approval::Request.define_user_association
      ::Approval::Comment.define_user_association
    end
  end
end

require "approval/config"
require "approval/engine" if defined?(::Rails)
require "approval/version"
