class CartItem < ApplicationRecord
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  attr_accessor :discount

  def adjusted_price
    # Calculates the price per unit based on product code and quantity.
    # - "GR1": Buy-one-get-one-free, so only half the units are paid (rounded up).
    # - "SR1": If 3 or more, price drops to 4.50 per unit.
    # - "CF1": If 3 or more, price drops to 2/3 (66.67%) of base price per unit.
    # - Otherwise, returns base price.
    case product.code
    when "GR1"
      PricingRules::BogoRule.new(item: self).apply
    when "SR1"
      PricingRules::BulkFixedPriceRule.new(item: self).apply
    when "CF1"
      PricingRules::BulkPercentageDiscountRule.new(item: self).apply
    else
      product.price
    end
  end

  def total_price
    (adjusted_price * quantity).round(2)
  end

  def as_json(options = {})
    super(
      only: [ :id, :quantity ]
    ).merge(
      adjusted_price: adjusted_price.to_f.round(2),
      total_price: total_price.to_f.round(2),
      product: {
        id: product.id,
        code: product.code,
        name: product.name,
        price: product.price.to_f.round(2)
      }
    )
  end
end
