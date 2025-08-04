require "rails_helper"
require "ostruct"

RSpec.describe PricingRules::BogoRule, type: :service do
  let(:product) { create(:product, code: "GR1", name: "Green Tea", price: 3.11) }
  let(:cart_item) { OpenStruct.new(product: product, quantity: quantity, discount: 0) }
  let(:rule) { described_class.new(item: cart_item) }

  describe "#apply" do
    context "when the cart item qualifies for Buy One Get One" do
      let(:quantity) { 2 }

      it "applies the discount" do
        expect { rule.apply }.to change { cart_item.discount.round(2) }.from(0).to(1.56)
      end
    end

    context "when the cart item does not qualify for Buy One Get One" do
      let(:quantity) { 1 }

      it "does not apply any discount" do
        expect { rule.apply }.not_to change { cart_item.adjusted_price }
      end
    end
  end
end
