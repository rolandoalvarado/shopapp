require "rails_helper"
require "ostruct"

RSpec.describe PricingRules::BulkPercentageDiscountRule, type: :service do
  let(:product) { create(:product, name: "Coffee", code: "CF1", price: 11.23) }

  let(:rule) do
    described_class.new(item: cart_item)
  end

  describe "#apply" do
    context "when quantity meets the threshold" do
      let(:cart_item) { OpenStruct.new(product: product, quantity: 3, discount: nil) }

      it "applies a percentage discount" do
        rule.apply
        original_total = 3 * 11.23
        new_price = (cart_item.product.price * 66.67 / 100).round(3)
        discounted_total = cart_item.quantity * new_price
        expected_discount = original_total - discounted_total

        expect(cart_item.discount.round(2)).to eq(expected_discount.round(2))
      end
    end

    context "when quantity is below the threshold" do
      let(:cart_item) { OpenStruct.new(product: product, quantity: 2, discount: nil) }

      it "does not apply any discount" do
        rule.apply
        expect(cart_item.discount).to be_nil
      end
    end
  end
end
