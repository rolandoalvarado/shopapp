require 'rails_helper'

RSpec.describe "Checkouts", type: :request do
  describe "GET /checkout" do
    let(:gr1) { create(:product, name: "Green Tea", code: "GR1", price: 3.11) }
    let(:sr1) { create(:product, name: "Strawberries", code: "SR1", price: 5.00) }
    let(:cf1) { create(:product, name: "Coffee", code: "CF1", price: 11.23) }

    before do
      create(:cart_item, product: gr1, quantity: 2) # Should trigger BOGO (1 free)
      create(:cart_item, product: sr1, quantity: 3) # Should apply bulk fixed price of 4.50 each
      create(:cart_item, product: cf1, quantity: 2) # Should apply 66.66% discount
    end

    let(:bogo_rule) { PricingRules::BogoRule.new(product_code: "GR1") }

    it "returns the expected total and item breakdowns" do
      get "/checkout"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["items"].size).to eq(3)

      green_tea_item = json["items"].find { |item| item["code"] == "GR1" }
      expect(green_tea_item["discount"].to_f).to eq(3.11)

      # coffee_item = json["items"].find { |item| item["code"] == "CF1" }
      # expect(coffee_item["discount"].to_f).to eq(0)
      # expect(coffee_item["subtotal"].to_f).to eq(11.23 * 2)

      # strawberry_item = json["items"].find { |item| item["code"] == "SR1" }
      # expect(strawberry_item["price"]).to eq(5.0)
      # expect(strawberry_item["discount"]).to eq(1.50) # (5.00 - 4.50) * 3

      # expect(json["total"]).to be < 11.23 * 2 + 5.00 * 3 + 3.11 * 2
    end
  end
end
