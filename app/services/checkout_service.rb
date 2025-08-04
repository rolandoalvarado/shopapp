class CheckoutService
  attr_reader :cart_items, :pricing_rules

  def initialize(cart_items:, pricing_rules: [])
    @cart_items = cart_items
    @pricing_rules = pricing_rules
  end

  def total
    pricing_rules.each { |rule| rule.apply }

    cart_items.sum do |item|
      subtotal = item.product.price * item.quantity
      discount = item.adjusted_price.to_f * item.quantity
      subtotal - discount
    end
  end
end
