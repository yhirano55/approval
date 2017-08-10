module Approval
  module Mixins
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_approval_resource(ignore_fields: [])
        include ::Approval::Mixins::Resource
        assign_ignore_fields(ignore_fields)
      end

      def acts_as_approval_user
        include ::Approval::Mixins::User
      end
    end
  end
end

require "approval/mixins/resource"
require "approval/mixins/user"
