module Approval
  module Mixins
    module Resource
      extend ActiveSupport::Concern

      DEFAULT_IGNORE_FIELDS = %w[id created_at updated_at].freeze

      included do
        class_attribute :approval_ignore_fields
        has_many :approval_items, class_name: :"Approval::Item", as: :resource
      end

      class_methods do
        def append_ignore_fields(ignore_fields = [])
          self.approval_ignore_fields = DEFAULT_IGNORE_FIELDS.dup.concat(ignore_fields).map(&:to_s).uniq
        end
      end

      def params_for_approval
        attributes.except(*approval_ignore_fields).compact
      end
    end
  end
end
