module Tray
  module Models
    class LineItem
      include Virtus.model

      attribute :id, Integer, default: -> _, attribute {UUID.generate}
      attribute :product_model, Symbol
      attribute :product_id, Integer
      attribute :quantity, Integer, default: 0
      attribute :options, Hash, default: {}
      attribute :created_at, DateTime, default: -> _, attribute {Time.now}

      def entity
        @entity ||= Cart::PRODUCT_KEYS.invert[product_model].find(product_id)
      end

      def options
        (super || {}).with_indifferent_access
      end

      def delivery_fee
        return 0 unless options[:delivery_method].to_s == "mail"
        entity.event.mailing_fee_in_cents
      end
    end
  end
end