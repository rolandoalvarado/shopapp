require "rails_helper"
require "ostruct"

RSpec.describe CheckoutService, type: :service do
  let(:coffee) { create(:product, code: "CF1", name: "Coffee", price: 11.23) }
  let(:tea) { create(:product, code: "GR1", name: "Green Tea", price: 3.00) }

  describe "#total" do
    context "without any pricing rules" do
      let(:cart_items) do
        [
          OpenStruct.new(product: coffee, quantity: 2, discount: nil),
          OpenStruct.new(product: tea, quantity: 1, discount: nil)
        ]
      end

      it "calculates total without discounts" do
        checkout = described_class.new(cart_items: cart_items)
        expected_total = (2 * 11.23) + (1 * 3.00)

        expect(checkout.total.round(2)).to eq(expected_total.round(2))
      end
    end

    context "with a discount rule" do
      let(:cart_items) do
        [
          OpenStruct.new(product: coffee, quantity: 3, discount: nil),
          OpenStruct.new(product: tea, quantity: 1, discount: nil)
        ]
      end

      let(:rule) do
        Class.new do
          def apply(cart_items)
            coffee_item = cart_items.find { |item| item.product.code == "CF1" }
            return unless coffee_item

            original_total = coffee_item.quantity * coffee_item.product.price
            discount = original_total * 0.10
            coffee_item.discount ||= 0
            coffee_item.discount += discount
          end
        end.new
      end

      it "applies discount from rule and returns correct total" do
        checkout = described_class.new(cart_items: cart_items, pricing_rules: [ rule ])
        total = checkout.total

        original_total = (3 * 11.23) + 3.00
        expected_discount = 3 * 11.23 * 0.10
        expected_total = original_total - expected_discount

        expect(total.round(2)).to eq(expected_total.round(2))
      end
    end

    context "when discount is already present" do
      let(:cart_items) do
        [
          OpenStruct.new(product: coffee, quantity: 1, discount: 1.23)
        ]
      end

      it "deducts existing discount from subtotal" do
        checkout = described_class.new(cart_items: cart_items)
        expected_total = 11.23 - 1.23

        expect(checkout.total.round(2)).to eq(expected_total.round(2))
      end
    end
  end
end
