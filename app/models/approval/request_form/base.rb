module Approval
  module RequestForm
    class Base
      include ::ActiveModel::Model
      include ::Approval::FormNotifiable

      attr_accessor :user, :reason, :records

      def initialize(user:, reason:, records:)
        @user    = user
        @reason  = reason
        @records = records
      end

      validates :user,    presence: true
      validates :reason,  presence: true, length: { maximum: Approval.config.comment_maximum }
      validates :records, presence: true

      def save
        return false unless valid?

        prepare(&:save)
      end

      def save!
        raise ::ActiveRecord::RecordInvalid unless valid?

        prepare(&:save!)
      end

      def request
        @request ||= user.approval_requests.new
      end

      def error_full_messages
        [errors, request.errors].flat_map(&:full_messages)
      end

      private

        def prepare
          raise NotImplementedError, "you must implement #{self.class}##{__method__}"
        end
    end
  end
end
