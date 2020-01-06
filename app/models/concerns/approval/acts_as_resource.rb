module Approval
  module ActsAsResource
    extend ActiveSupport::Concern

    included do
      class_attribute :approval_ignore_fields
      self.approval_ignore_fields = %w[id created_at updated_at]

      has_many :approval_items, class_name: :"Approval::Item", as: :resource
    end

    class_methods do
      def assign_ignore_fields(ignore_fields = [])
        self.approval_ignore_fields = approval_ignore_fields.concat(ignore_fields).map(&:to_s).uniq
      end
    end

    def create_params_for_approval
      attributes.except(*approval_ignore_fields).compact
    end

    def update_params_for_approval
      changes.except(*approval_ignore_fields).each_with_object({}) {|(k, v), h| h[k] = v.last }
    end
  end
end
