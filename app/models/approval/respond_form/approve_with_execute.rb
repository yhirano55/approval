module Approval
  module RespondForm
    class ApproveWithExecute < Base
      validate :ensure_user_cannot_respond_to_my_request

      private

        def prepare
          ::Approval::Request.transaction do
            request.lock!
            request.assign_attributes(state: :approved, approved_at: Time.current, respond_user_id: user.id)
            request.comments.new(user_id: user.id, content: reason)
            request.execute
            yield(request)
          end
        end
    end
  end
end
