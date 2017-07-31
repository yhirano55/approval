module Approval
  module RespondForm
    class Cancel < Base
      private

        def prepare
          ::ActiveRecord::Base.transaction do
            request.lock!
            request.assign_attributes(state: :cancelled, cancelled_at: Time.current, respond_user: user)
            request.comments.new(user: user, content: reason)
            yield(request)
          end
        end
    end
  end
end
