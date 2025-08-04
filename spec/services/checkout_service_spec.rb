require "rails_helper"
require "ostruct"

RSpec.describe CheckoutService, type: :service do
  let(:coffee) { create(:product, code: "CF1", name: "Coffee", price: 11.23) }
  let(:tea)    { create(:product, code: "GR1", name: "Green Tea", price: 3.00) }

  describe "#total" do
    context "without any pricing rules" do
      let(:cart_items) do
        [
          OpenStruct.new(product: coffee, quantity: 2, adjusted_price: 0),
          OpenStruct.new(product: tea, quantity: 1, adjusted_price: 0)
        ]
      end

      it "calculates total without discounts" do
        checkout = described_class.new(cart_items: cart_items)
        expected_total = (2 * 11.23) + (1 * 3.00)

        expect(checkout.total.round(2)).to eq(expected_total.round(2))
      end
    end

    context "with a discount rule applied" do
      let(:cart_items) do
        [
          OpenStruct.new(product: coffee, quantity: 3, adjusted_price: 0),
          OpenStruct.new(product: tea, quantity: 1, adjusted_price: 0)
        ]
      end

      let(:rule) do
        instance_double("PricingRule").tap do |mock|
          allow(mock).to receive(:apply) do
            coffee_item = cart_items.find { |item| item.product.code == "CF1" }
            discount_per_unit = coffee_item.product.price * 66.67 / 100
            coffee_item.adjusted_price = discount_per_unit
          end
        end
      end

      it "applies adjusted price discount and returns correct total" do
        checkout = described_class.new(cart_items: cart_items, pricing_rules: [ rule ])
        total = checkout.total

        original_total = (3 * 11.23) + (1 * 3.00)
        expected_discount = 3 * (11.23 * 66.67 / 100)
        expected_total = original_total - expected_discount

        expect(total.round(2)).to eq(expected_total.round(2))
      end
    end

    context "when adjusted_price is already set" do
      let(:cart_items) do
        [
          OpenStruct.new(product: coffee, quantity: 2, adjusted_price: 1.23)
        ]
      end

      it "deducts adjusted_price * quantity from subtotal" do
        checkout = described_class.new(cart_items: cart_items)
        subtotal = 2 * 11.23
        expected_total = subtotal - (2 * 1.23)

        expect(checkout.total.round(2)).to eq(expected_total.round(2))
      end
    end
  end
end
