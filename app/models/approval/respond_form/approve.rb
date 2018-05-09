module Approval
  module RespondForm
    class Approve < Base
      validate :ensure_user_cannot_respond_to_my_request

      private

        def prepare
          instrument "approve" do |payload|
            ::Approval::Request.transaction do
              request.lock!
              request.assign_attributes(state: :approved, approved_at: Time.current, respond_user_id: user.id)
              payload[:comment] = request.comments.new(user_id: user.id, content: reason)
              yield(request)
            end
          end
        end
    end
  end
end
