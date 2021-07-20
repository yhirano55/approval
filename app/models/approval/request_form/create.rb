# frozen_string_literal: true

module Approval
  module RequestForm
    class Create < Base
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
                event: 'create',
                resource_type: record.class.to_s,
                params: record.create_params_for_approval
              )
            end
            yield(request)
          end
        end
      end
    end
  end
end
