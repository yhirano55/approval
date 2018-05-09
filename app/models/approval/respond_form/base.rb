module Approval
  module RespondForm
    class Base
      include ::ActiveModel::Model
      include ::Approval::FormNotifiable

      attr_accessor :user, :reason, :request

      def initialize(user:, reason:, request:)
        @user    = user
        @reason  = reason
        @request = request
      end

      validates :user,    presence: true
      validates :reason,  presence: true, length: { maximum: Approval.config.comment_maximum }
      validates :request, presence: true

      def save
        return false unless valid?

        prepare(&:save)
      end

      def save!
        raise ::ActiveRecord::RecordInvalid unless valid?

        prepare(&:save!)
      end

      private

        def prepare
          raise NotImplementedError, "you must implement #{self.class}##{__method__}"
        end

        def ensure_user_cannot_respond_to_my_request
          return if Approval.config.permit_to_respond_to_own_request?

          errors.add(:user, :cannot_respond_to_own_request) if user.try(:id) == request.request_user_id
        end
    end
  end
end
