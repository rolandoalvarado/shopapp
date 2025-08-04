module PricingRules
  class BogoRule < BaseRule
    attr_reader :product_code

    def initialize(product_code:)
      @product_code = product_code
    end

    def apply(cart_items)
      item = cart_items.find { |item| item.product.code == @product_code }
      return unless item && item.quantity >= 2

      free = item.quantity / 2
      item.discount ||= 0
      item.discount += item.product.price * free
    end
  end
end
