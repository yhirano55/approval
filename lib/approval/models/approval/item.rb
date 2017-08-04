module Approval
  class Item < ::ActiveRecord::Base
    class UnexistResource < StandardError; end

    EVENTS = %w[create update destroy].freeze

    self.table_name_prefix = "approval_".freeze

    belongs_to :request, class_name: :"Approval::Request", inverse_of: :items
    belongs_to :resource, polymorphic: true, optional: true

    serialize :params, Hash

    with_options presence: true do
      validates :resource_id, unless: :create_event?
      validates :resource_type
      validates :event, inclusion: { in: EVENTS }
      validates :params, if: :update_event?
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
        @_resource_model ||= resource_type.to_s.safe_constantize
      end

      def ensure_resource_be_valid
        return if resource_model.nil? || destroy_event?
        record = resource_model.new(params || {})

        unless record.valid?
          record.errors.full_messages.each do |message|
            errors.add(:base, message)
          end
        end
      end
  end
end
