module PricingRules
  class BulkFixedPriceRule < BaseRule
    attr_reader :product_code, :threshold, :new_price

    def initialize(product_code:, threshold:, new_price:)
      @product_code = product_code
      @threshold = threshold
      @new_price = new_price
    end

    def apply(cart_items)
      item = cart_items.find { |item| item.product.code == @product_code }
      return unless item && item.quantity >= @threshold

      original_total = item.quantity * item.product.price
      discounted_total = item.quantity * @new_price
      item.discount ||= 0
      item.discount += original_total - discounted_total
    end
  end
end
