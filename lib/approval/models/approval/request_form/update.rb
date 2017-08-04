module Approval
  module RequestForm
    class Update < Base
      private

        def prepare
          ::Approval::Request.transaction do
            request = user.approval_requests.new
            request.comments.new(user: user, content: reason)
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
