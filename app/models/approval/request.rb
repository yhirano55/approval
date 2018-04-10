module Approval
  class Request < ApplicationRecord
    class NotApprovedError < StandardError; end
    self.table_name = :approval_requests

    def self.define_user_association
      belongs_to :request_user, class_name: Approval.config.user_class_name
      belongs_to :respond_user, class_name: Approval.config.user_class_name, optional: true
    end

    has_many :comments, class_name: :"Approval::Comment", inverse_of: :request, dependent: :destroy
    has_many :items,    class_name: :"Approval::Item",    inverse_of: :request, dependent: :destroy

    enum state: { pending: 0, cancelled: 1, approved: 2, rejected: 3, executed: 4 }

    scope :recently, -> { order(id: :desc) }

    validates :state,        presence: true
    validates :respond_user, presence: true, unless: :pending?
    validates :comments,     presence: true
    validates :items,        presence: true

    validates_associated :comments
    validates_associated :items

    validate :ensure_state_was_pending

    before_create do
      self.requested_at = Time.current
    end

    def execute
      raise NotApprovedError unless approved?

      self.state = :executed
      self.executed_at = Time.current
      items.each(&:apply)
    end

    private

      def ensure_state_was_pending
        return unless persisted?

        errors.add(:base, :already_performed) if state_was != "pending"
      end
  end
end
