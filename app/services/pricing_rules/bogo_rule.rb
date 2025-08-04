module PricingRules
  class BogoRule < BaseRule
    attr_reader :item

    def initialize(item:)
      @item = item
    end

    def apply
      return 0 if item.quantity <= 0

      paid_units = (item.quantity / 2.0).ceil
      item.discount = (item.product.price * paid_units / item.quantity).round(3)
    end
  end
end
