module Approval
  class Item < ApplicationRecord
    class UnexistResource < StandardError; end

    self.table_name = :approval_items
    EVENTS = %w[create update destroy].freeze

    belongs_to :request, class_name: :"Approval::Request", inverse_of: :items
    belongs_to :resource, polymorphic: true, optional: true

    serialize :params, Hash

    validates :resource_type, presence: true
    validates :event,         presence: true, inclusion: { in: EVENTS }

    with_options unless: :create_event? do
      validates :resource_id, presence: true
    end

    with_options if: :update_event? do
      validates :params, presence: true
    end

    validate :ensure_resource_be_valid

    EVENTS.each do |event_name|
      define_method "#{event_name}_event?" do
        event_name.to_s == event.to_s
      end
    end

    def apply
      case event
      when "create"
        resource_model.create!(params).tap do |created_resource|
          update!(resource_id: created_resource.id)
        end
      when "update"
        raise UnexistResource unless resource

        resource.update!(params)
      when "destroy"
        raise UnexistResource unless resource

        resource.destroy
      end
    end

    private

      def resource_model
        @resource_model ||= resource_type.to_s.safe_constantize
      end

      def ensure_resource_be_valid
        return if resource_model.nil? || destroy_event?

        record = if resource_id.present?
                   resource_model.find(resource_id).tap {|m| m.assign_attributes(params) }
                 else
                   resource_model.new(params || {})
                 end

        unless record.valid?
          errors.add(:base, :invalid)
          record.errors.full_messages.each do |message|
            request.errors.add(:base, message)
          end
        end
      end
  end
end
