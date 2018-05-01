module Approval
  module RequestForm
    class Create < Base
      private

        def prepare
          ActiveSupport::Notifications.instrument("request.approval", user: user) do |payload|
            ::Approval::Request.transaction do
              payload[:request] = request
              payload[:comment] = request.comments.new(user_id: user.id, content: reason)
              Array(records).each do |record|
                request.items.new(
                  event: "create",
                  resource_type: record.class.to_s,
                  params: record.create_params_for_approval,
                )
              end
              yield(request)
            end
          end
        end
    end
  end
end
