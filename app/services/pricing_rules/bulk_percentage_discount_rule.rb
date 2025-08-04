module PricingRules
  class BulkPercentageDiscountRule < BaseRule
    attr_reader :item, :threshold, :percentage

    def initialize(item:, threshold: 3, percentage: 66.67) # 66.67 = 2/3
      @item = item
      @threshold = threshold
      @percentage = percentage / 100.0 # Convert to decimal
    end

    def apply
      return 0 if item.quantity <= 0

      if item.quantity >= threshold
        apply_bulk_percentage_discount
      else
        item.product.price
      end
    end

    private

    def apply_bulk_percentage_discount
      new_price = (item.product.price * percentage).round(3)
      original_total = item.quantity * item.product.price
      discounted_total = item.quantity * new_price
      item.discount ||= 0.0
      item.discount += original_total - discounted_total
      new_price
    end
  end
end
