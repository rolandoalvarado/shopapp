class ProductsController < ApplicationController
  def index
    render json: Product.all, status: :ok
  end

  def show
  end
end
