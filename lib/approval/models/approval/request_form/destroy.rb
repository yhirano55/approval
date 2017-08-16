module Approval
  module RequestForm
    class Destroy < Base
      private

        def prepare
          ::Approval::Request.transaction do
            request.comments.new(user: user, content: reason)
            Array(records).each do |record|
              request.items.new(
                event: "destroy",
                resource_type: record.class.to_s,
                resource_id: record.id,
              )
            end
            yield(request)
          end
        end
    end
  end
end
