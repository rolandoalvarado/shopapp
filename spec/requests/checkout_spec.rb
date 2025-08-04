require "rails_helper"

RSpec.describe "Checkout", type: :request do
  describe "POST /checkout" do
    let!(:product) { create(:product, code: "GR1", name: "Green Tea", price: 3.11) }
    let!(:cart_item) { create(:cart_item, product: product, quantity: 2) }

    let(:valid_params) do
      {
        cart_items: [
          {
            id: cart_item.id
          }
        ]
      }
    end

    it "returns cart item details including discount and total price" do
      post "/checkout", params: valid_params

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["cart_items"]).to be_an(Array)
      expect(json["cart_items"].size).to eq(1)

      item = json["cart_items"].first
      expect(item["id"]).to eq(cart_item.id)
      expect(item["product"]["id"]).to eq(product.id)
      expect(item["product"]["code"]).to eq("GR1")
      expect(item["product"]["name"]).to eq("Green Tea")
      expect(item["product"]["price"]).to eq("3.11")
      expect(item["quantity"]).to eq(2)
      expect(item["total_price"].to_f).to eq(cart_item.total_price)
      expect(item["discount"].to_f).to eq(cart_item.discount)
      expect(item["adjusted_price"].to_f).to eq(cart_item.adjusted_price)
    end
  end
end
