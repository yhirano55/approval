# frozen_string_literal: true

module Approval
  module RequestForm
    class Update < Base
      private

      def prepare
        instrument 'request' do |payload|
          ::Approval::Request.transaction do
            request.tenant_id = tenant.id if ::Approval.config.tenancy
            payload[:comment] = request.comments.new(
              user_id: user.id, content: reason, type: :request
            )
            Array(records).each do |record|
              request.items.new(
                event: 'update',
                resource_type: record.class.to_s,
                resource_id: record.id,
                params: record.update_params_for_approval
              )
            end
            yield(request)
          end
        end
      end
    end
  end
end
