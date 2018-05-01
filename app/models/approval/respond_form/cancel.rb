module Approval
  module RespondForm
    class Cancel < Base
      private

        def prepare
          ActiveSupport::Notifications.instrument("cancel.approval", user: user) do |payload|
            ::Approval::Request.transaction do
              payload[:request] = request.lock!
              request.assign_attributes(state: :cancelled, cancelled_at: Time.current, respond_user_id: user.id)
              payload[:comment] = request.comments.new(user_id: user.id, content: reason)
              yield(request)
            end
          end
        end
    end
  end
end
