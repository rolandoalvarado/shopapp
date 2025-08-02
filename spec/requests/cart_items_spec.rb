require 'rails_helper'

RSpec.describe "CartItems", type: :request do
  let(:product) { create(:product) }

  describe "POST /create" do
    it "creates a new cart item" do
      post "/cart_items", params: { product_id: product.id, quantity: 1 }

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Item added to cart successfully")
      expect(json_response["cart_item"]["product_id"]).to eq(product.id)
    end

    it "returns an error when product_id is missing" do
      post "/cart_items", params: { quantity: 1 }

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Invalid parameters")
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "handles unexpected errors" do
      allow(CartItem).to receive(:create!).and_raise(StandardError.new("Unexpected error"))

      post "/cart_items", params: { product_id: product.id, quantity: 1 }

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Unexpected error")
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
