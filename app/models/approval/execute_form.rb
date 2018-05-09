module Approval
  class ExecuteForm
    include ::ActiveModel::Model
    include ::Approval::FormNotifiable

    attr_accessor :user, :reason, :request

    def initialize(user:, reason:, request:)
      @user    = user
      @reason  = reason
      @request = request
    end

    validates :user,    presence: true
    validates :request, presence: true
    validates :reason,  allow_blank: true, length: { maximum: Approval.config.comment_maximum }

    validate :ensure_request_is_approved
    validate :ensure_user_same_as_request_user

    def save
      return false unless valid?

      execute(&:save)
    end

    def save!
      raise ::ActiveRecord::RecordInvalid unless valid?

      execute(&:save!)
    end

    private

      def execute
        instrument "execute" do |payload|
          ::Approval::Request.transaction do
            request.lock!
            payload[:comment] = request.comments.new(user_id: user.id, content: reason) if reason
            request.execute
            yield(request)
          end
        end
      end

      def ensure_request_is_approved
        return unless request

        errors.add(:request, :is_not_approved) unless request.approved?
      end

      def ensure_user_same_as_request_user
        return unless user && request

        unless user.id == request.request_user_id
          errors.add(:user, :cannot_execute_others_request)
        end
      end
  end
end
