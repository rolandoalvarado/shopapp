class CheckoutsController < ApplicationController
  def show
    cart_items = CartItem.includes(:product).map do |item|
      OpenStruct.new(product: item.product, quantity: item.quantity, discount: 0)
    end

    puts "cart_items: #{cart_items.inspect}"

    rules = [
      PricingRules::BogoRule.new(product_code: "GR1"),
      PricingRules::BulkFixedPriceRule.new(product_code: "SR1", threshold: 3, new_price: 4.50),
      PricingRules::BulkPercentageDiscountRule.new(product_code: "CF1", threshold: 2, discount_percentage: 66.66)
    ]

    checkout = CheckoutService.new(cart_items: cart_items, pricing_rules: rules)

    render json: {
      items: cart_items.map do |item|
        {
          name: item.product.name,
          code: item.product.code,
          price: item.product.price,
          quantity: item.quantity,
          discount: item.discount,
          subtotal: item.product.price * item.quantity - item.discount.to_f
        }
      end,
      total: checkout.total.round(2)
    }
  end
end
