class CartItemsController < ApplicationController
  def create
    @cart_item = CartItem.create!(product_id: params[:product_id], quantity: params[:quantity] || 1)

    if @cart_item.persisted?
      render json: { message: "Item added to cart successfully", cart_item: @cart_item }, status: :created
    else
      render json: { error: "Failed to add item to cart" }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordInvalid => e
    render json: { error: "Invalid parameters" }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
