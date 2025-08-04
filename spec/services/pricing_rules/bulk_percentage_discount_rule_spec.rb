require "rails_helper"
require "ostruct"

RSpec.describe PricingRules::BulkPercentageDiscountRule do
  let(:product) { create(:product, name: "Coffee", code: "CF1", price: 11.23) }

  let(:rule) do
    described_class.new(product_code: product.code, threshold: 3, discount_percentage: 10)
  end

  describe "#apply" do
    context "when quantity meets the threshold" do
      let(:cart_item) { OpenStruct.new(product: product, quantity: 3, discount: nil) }

      it "applies a percentage discount" do
        rule.apply([ cart_item ])

        original_total = 3 * 11.23
        expected_discount = (original_total * 0.10).round(2)

        expect(cart_item.discount.round(2)).to eq(expected_discount)
      end
    end

    context "when quantity is below the threshold" do
      let(:cart_item) { OpenStruct.new(product: product, quantity: 2, discount: nil) }

      it "does not apply any discount" do
        rule.apply([ cart_item ])
        expect(cart_item.discount).to be_nil
      end
    end

    context "when product code does not match" do
      let(:other_product) { create(:product, code: "TEA1", name: "Tea", price: 5.00) }
      let(:cart_item) { OpenStruct.new(product: other_product, quantity: 3, discount: nil) }

      it "does not apply any discount" do
        rule.apply([ cart_item ])
        expect(cart_item.discount).to be_nil
      end
    end

    context "when discount already exists" do
      let(:cart_item) { OpenStruct.new(product: product, quantity: 3, discount: 2.00) }

      it "adds to the existing discount" do
        rule.apply([ cart_item ])

        additional_discount = (3 * 11.23 * 0.10).round(2)
        expect(cart_item.discount.round(2)).to eq((2.00 + additional_discount).round(2))
      end
    end
  end
end
