module Approval
  module Mixins
    def acts_as_approval_resource(ignore_fields: [])
      include ::Approval::ActsAsResource
      assign_ignore_fields(ignore_fields)
    end

    def acts_as_approval_user
      include ::Approval::ActsAsUser
    end
  end
end
