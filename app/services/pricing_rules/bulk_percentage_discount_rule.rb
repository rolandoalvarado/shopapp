module PricingRules
  class BulkPercentageDiscountRule < BaseRule
    attr_reader :product_code, :threshold, :discount_percentage

    def initialize(product_code:, threshold:, discount_percentage:)
      @product_code = product_code
      @threshold = threshold
      @discount_percentage = discount_percentage
    end

    def apply(cart_items)
      item = cart_items.find { |item| item.product.code == product_code }
      return unless item && item.quantity >= threshold

      original_total = item.product.price * item.quantity
      discount_total = original_total * (discount_percentage / 100.0)
      item.discount ||= 0
      item.discount += discount_total
    end
  end
end
