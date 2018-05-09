module Approval
  module FormNotifiable
    extend ActiveSupport::Concern

    private

    def instrument(operation, payload = {}, &block)
      payload.merge!(request: request, user: user, reason: reason)
      ActiveSupport::Notifications.instrument("#{operation}.approval", payload, &block)
    end
  end
end
