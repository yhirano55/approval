module Approval
  class Request < ApplicationRecord
    self.table_name = :approval_requests

    def self.define_user_association
      belongs_to :request_user, class_name: Approval.config.user_class_name
      belongs_to :respond_user, class_name: Approval.config.user_class_name, optional: true
    end

    def self.define_tenant_association
      belongs_to :tenant, dependent: false
    end

    has_many :comments, class_name: :"Approval::Comment", inverse_of: :request, dependent: :destroy
    has_many :items,    class_name: :"Approval::Item",    inverse_of: :request, dependent: :destroy

    enum state: { pending: 0, cancelled: 1, approved: 2, rejected: 3, executed: 4 }

    scope :recently, -> { order(id: :desc) }

    validates :state, :comments, :items, presence: true
    validates :respond_user, presence: true, unless: :pending?
    validates :tenant, presence: true, if: :tenancy?

    validates_associated :comments
    validates_associated :items

    validate :ensure_state_was_pending

    before_create do
      self.requested_at = Time.current
    end

    def execute
      self.state = :executed
      self.executed_at = Time.current
      items.each(&:apply)
    end

    def approved?
      approved_at.present?
    end

    def cancelled?
      cancelled_at.present?
    end

    def rejected?
      rejected_at.present?
    end

    def status
      return 'approved' if approved?
      return 'cancelled' if cancelled?
      return 'rejected' if rejected?
      return 'pending' if pending?
    end

    private

      def ensure_state_was_pending
        return unless persisted?

        if %w[pending approved].exclude?(state_was)
          errors.add(:base, :already_performed)
        end
      end

      def tenancy?
        ::Approval.config.tenancy
      end
  end
end
