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
end
