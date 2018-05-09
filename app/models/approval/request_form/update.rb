module Approval
  module RequestForm
    class Update < Base
      private

        def prepare
          instrument "request" do |payload|
            ::Approval::Request.transaction do
              payload[:comment] = request.comments.new(user_id: user.id, content: reason)
              Array(records).each do |record|
                request.items.new(
                  event: "update",
                  resource_type: record.class.to_s,
                  resource_id: record.id,
                  params: record.update_params_for_approval,
                )
              end
              yield(request)
            end
          end
        end
    end
  end
end
