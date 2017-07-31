module Approval
  module RespondForm
    class Reject < Base
      validate :ensure_user_cannot_respond_to_my_request

      private

        def prepare
          ::ActiveRecord::Base.transaction do
            request.lock!
            request.assign_attributes(state: :rejected, rejected_at: Time.current, respond_user: user)
            request.comments.new(user: user, content: reason)
            yield(request)
          end
        end
    end
  end
end
