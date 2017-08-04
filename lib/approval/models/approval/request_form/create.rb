module Approval
  module RequestForm
    class Create < Base
      private

        def prepare
          ::Approval::Request.transaction do
            request = user.approval_requests.new
            request.comments.new(user: user, content: reason)
            Array(records).each do |record|
              request.items.new(
                event: "create",
                resource_type: record.class.to_s,
                params: record.params_for_approval,
              )
            end
            yield(request)
          end
        end
    end
  end
end
