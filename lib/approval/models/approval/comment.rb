module Approval
  class Comment < ::ActiveRecord::Base
    self.table_name_prefix = "approval_".freeze

    belongs_to :request, class_name: :"Approval::Request", inverse_of: :comments
    belongs_to :user,    class_name: Approval.config.user_class_name

    validates :content, presence: true, length: { maximum: Approval.config.comment_maximum }
  end
end
