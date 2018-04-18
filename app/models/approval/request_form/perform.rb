module Approval
  module RequestForm
    class Perform < Base
      private

        def prepare
          ::Approval::Request.transaction do
            request.comments.new(user_id: user.id, content: reason)
            Array(records).each do |record|
              request.items.new(
                event: "perform",
                resource_type: record.class.to_s,
                params: extract_params_from(record),
              )
            end
            yield(request)
          end
        end

        def extract_params_from(record)
          record.try(:attributes) || record.try(:to_h) || {}
        end
    end
  end
end
