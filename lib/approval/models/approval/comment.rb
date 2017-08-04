module Approval
  class Comment < ::ActiveRecord::Base
    self.table_name_prefix = "approval_".freeze

    class << self
      def define_user_association(user_class_name)
        belongs_to :user, class_name: user_class_name.to_s
      end
    end

    belongs_to :request, class_name: :"Approval::Request", inverse_of: :comments

    validates :content, presence: true, length: { maximum: Approval.config.comment_maximum }
  end
end
