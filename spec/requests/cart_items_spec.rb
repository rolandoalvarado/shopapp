require 'rails_helper'

RSpec.describe "CartItems", type: :request do
  let(:product) { create(:product) }

  describe "GET /index" do
    it "returns a list of cart items with product details" do
      create(:cart_item, product: product)

      get "/cart_items"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(1)

      cart_item = json_response.first
      expect(cart_item["id"]).to eq(product.id)
      expect(cart_item["quantity"]).to eq(1)
      expect(cart_item["product"]).to include({
        "name" => product.name,
        "code" => product.code,
        "price" => product.price.to_d.to_s
      })
    end
  end

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

    context 'when product already exists in cart' do
      it "increments the quantity of the existing cart item" do
        create(:cart_item, product: product, quantity: 1)

        post "/cart_items", params: { product_id: product.id, quantity: 1 }

        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Item added to cart successfully")
        expect(json_response["cart_item"]["quantity"]).to eq(2)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:cart_item) { create(:cart_item, product: product) }

    it "deletes a cart item" do
      delete "/cart_items/#{cart_item.id}"

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Item removed from cart successfully")
      expect(response).to have_http_status(:ok)
      expect(CartItem.exists?(cart_item.id)).to be_falsey
    end

    it "returns an error when cart item does not exist" do
      delete "/cart_items/9999"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Cart item not found")
      expect(response).to have_http_status(:not_found)
    end

    it "handles unexpected errors" do
      allow(CartItem).to receive(:find).and_raise(StandardError.new("Unexpected error"))

      delete "/cart_items/#{cart_item.id}"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Unexpected error")
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
