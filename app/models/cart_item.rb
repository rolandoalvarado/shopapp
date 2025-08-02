class CartItem < ApplicationRecord
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def adjusted_price
    # Calculates the price per unit based on product code and quantity.
    # - "GR1": Buy-one-get-one-free, so only half the units are paid (rounded up).
    # - "SR1": If 3 or more, price drops to 4.50 per unit.
    # - "CF1": If 3 or more, price drops to 2/3 of base price per unit.
    # - Otherwise, returns base price.
    base_price = product.price
    case product.code
    when "GR1"
      effective_units_paid = (quantity / 2.0).ceil
      (product.price * effective_units_paid / quantity).round(3)
    when "SR1"
      quantity >= 3 ? 4.50 : base_price
    when "CF1"
      quantity >= 3 ? (base_price * 2 / 3).round(3) : base_price
    else
      base_price
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
        name: product.name,
        price: product.price.to_f.round(2)
      }
    )
  end
end
