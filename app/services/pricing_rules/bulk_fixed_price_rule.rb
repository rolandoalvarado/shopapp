module PricingRules
  class BulkFixedPriceRule < BaseRule
    attr_reader :item, :threshold, :new_price

    def initialize(item:, threshold: 3, new_price: 4.50)
      @item = item
      @threshold = threshold
      @new_price = new_price
    end

    def apply
      return 0.0 if item.quantity <= 0

      if item.quantity >= threshold
        apply_bulk_discount
      else
        item.product.price
      end
    end

    private

    def apply_bulk_discount
      original_total = item.quantity * item.product.price
      discounted_total = item.quantity * new_price
      item.discount ||= 0.0
      item.discount += original_total - discounted_total
      new_price
    end
  end
end
