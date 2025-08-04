require "rails_helper"
require "ostruct"

RSpec.describe PricingRules::BogoRule, type: :service do
  let(:product) { create(:product, code: "GR1", name: "Green Tea", price: 3.11) }
  let(:cart_item) { OpenStruct.new(product: product, quantity: quantity, discount: 0) }
  let(:cart_items) { [ cart_item ] }
  let(:rule) { described_class.new(product_code: product.code) }

  describe "#apply" do
    context "when the cart item qualifies for Buy One Get One" do
      let(:quantity) { 2 }

      it "applies the discount" do
        expect { rule.apply(cart_items) }.to change { cart_item.discount }.from(0).to(3.11)
      end
    end

    context "when the cart item does not qualify for Buy One Get One" do
      let(:quantity) { 1 }

      it "does not apply any discount" do
        expect { rule.apply(cart_items) }.not_to change { cart_item.discount }
      end
    end
  end
end
