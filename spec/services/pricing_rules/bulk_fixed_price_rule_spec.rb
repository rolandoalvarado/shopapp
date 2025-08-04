require 'rails_helper'
require 'ostruct'

RSpec.describe PricingRules::BulkFixedPriceRule, type: :service do
  let(:product) { create(:product, code: "SR1", name: "Strawberries", price: 5.0) }

  describe "#apply" do
    context "when quantity meets the threshold" do
      let(:cart_item) { OpenStruct.new(product: product, quantity: 3, discount: 0) }

      it "applies the fixed price discount to the cart item" do
        rule = described_class.new(item: cart_item)

        rule.apply

        original_total = 3 * 5.00 # 15.00
        discounted_total = 3 * 4.50 # 13.50
        expected_discount = original_total - discounted_total # 1.50

        expect(cart_item.discount).to eq(expected_discount)
      end
    end

    context "when quantity is below the threshold" do
      let(:cart_item) { OpenStruct.new(product: product, quantity: 2, discount: nil) }

      it "does not apply any discount" do
        rule = described_class.new(item: cart_item, threshold: 3, new_price: 4.00)

        rule.apply

        expect(cart_item.discount).to be_nil
      end
    end
  end
end
