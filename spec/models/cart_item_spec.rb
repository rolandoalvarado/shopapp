require 'rails_helper'

RSpec.describe CartItem, type: :model do
  subject { create(:cart_item) }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }

    it "does not allow decimal quantity" do
      cart_item = CartItem.new(quantity: 1.5, product: build(:product))
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include("must be an integer")
    end
  end

  describe '#adjusted_price' do
    let(:product) { create(:product, code: 'SR1', price: 5.00) }

    context 'when product code is GR1' do
      let(:product) { create(:product, code: 'GR1', price: 3.11) }

      it "calculates adjusted total price buy-one-get-one-free" do
        cart_item = CartItem.new(product: product, quantity: 2)
        expect(cart_item.adjusted_price).to eq(1.555) # 3.11 / 2
        expect(cart_item.total_price.round(2)).to eq(3.11) # 1 unit paid for 3.11, 1 free
      end
    end

    context 'when product code is SR1' do
      let(:product) { create(:product, code: 'SR1', price: 5.00) }

      it "calculates adjusted price for SR1 with special pricing" do
        cart_item = CartItem.new(product: product, quantity: 3)
        expect(cart_item.adjusted_price).to eq(4.50) # Special price for 3 or more
        expect(cart_item.total_price.round(2)).to eq(13.5) # 4.50 * 3 = 13.5
      end
    end

    context 'when product code is CF1' do
      let(:product) { create(:product, code: 'CF1', price: 11.23) }

      it "calculates adjusted price for CF1 with special pricing" do
        cart_item = CartItem.new(product: product, quantity: 3)
        expect(cart_item.adjusted_price).to be_within(0.01).of(7.48) # (11.23 * 2/3)
        expect(cart_item.total_price.round(2)).to eq(22.46) # (11.23 * 2/3) * 3 = 22.46
      end
    end

    it "returns base price for other products" do
      cart_item = CartItem.new(product: product, quantity: 2)
      expect(cart_item.adjusted_price).to eq(product.price)
      expect(cart_item.total_price.round(2)).to eq(10.0) # Product price is 5.00, total for 2 units is 10.00
    end
  end

  describe '#total_price' do
    let(:product) { create(:product, code: 'GR1', price: 3.11) }
    let(:cart_item) { CartItem.new(product: product, quantity: 2) }

    it "calculates the total price based on adjusted price" do
      expect(cart_item.total_price).to eq(cart_item.adjusted_price * cart_item.quantity)
    end
  end

  describe '#as_json' do
    let(:product) { create(:product, name: 'Test Product', price: 10.00) }
    let(:cart_item) { CartItem.new(product: product, quantity: 2) }

    it "returns JSON representation with adjusted price and total price" do
      expected_json = {
        "id" => cart_item.id,
        "quantity" => 2,
        adjusted_price: cart_item.adjusted_price.to_f.round(2),
        total_price: cart_item.total_price.to_f.round(2),
        product: {
          id: product.id,
          code: product.code,
          name: product.name,
          price: product.price.to_f.round(2)
        }
      }

      expect(cart_item.as_json).to eq(expected_json)
    end
  end
end
