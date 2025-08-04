class CheckoutController < ApplicationController
  def create
    # Preparing data for checkout process.
    # Sending request to payment gateway.
    # Handling response from payment gateway.
    # Email receipt to customer

    # Preload cart items
    cart_items = CartItem.includes(:product).where(id: params[:cart_items].map { |item| item[:id] })

    render json: {
      cart_items: cart_items.map { |item|
        {
          id: item.id,
          product: {
            id: item.product.id,
            code: item.product.code,
            name: item.product.name,
            price: item.product.price
          },
          quantity: item.quantity,
          adjusted_price: item.adjusted_price,
          total_price: item.total_price,
          discount: item.discount
        }
      }
    }
  end
end
