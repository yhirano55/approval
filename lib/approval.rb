module Approval
  def self.config
    @_config ||= Config.new
  end

  def self.configure
    yield config
  end
end

require "approval/config"
require "approval/engine" if defined?(::Rails)
require "approval/version"
