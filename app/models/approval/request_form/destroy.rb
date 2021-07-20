# frozen_string_literal: true

module Approval
  module RequestForm
    class Destroy < Base
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
                event: 'destroy',
                resource_type: record.class.to_s,
                resource_id: record.id
              )
            end
            yield(request)
          end
        end
      end
    end
  end
end
