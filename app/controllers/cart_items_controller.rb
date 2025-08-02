class CartItemsController < ApplicationController
  def index
    @cart_items = CartItem.includes(:product)
    # Return cart items with product details
    render json: @cart_items.as_json(include: { product: { only: [ :code, :name, :price ] } })
  end

  def create
    product_id = params[:product_id]
    quantity = [ params[:quantity].to_i, 1 ].max

    cart_item = CartItem.find_by(product_id: product_id)

    if cart_item
      cart_item.increment!(:quantity, quantity)
    else
      cart_item = CartItem.create!(product_id: product_id, quantity: quantity)
    end

    # Return success message with cart item details
    render json: { message: "Item added to cart successfully", cart_item: cart_item }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: "Invalid parameters" }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
