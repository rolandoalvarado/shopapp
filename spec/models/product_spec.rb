require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { create(:product) }

  it { should be_valid }

  describe 'associations' do
    it { should have_many(:cart_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }

    it do
      is_expected.to validate_numericality_of(:price).is_greater_than(0)
    end

    context "price decimal validation" do
      it "allows price with two decimal places" do
        product = build(:product, price: 19.99)
        expect(product).to be_valid
      end

      it "rejects price with more than two decimal places" do
        product = build(:product, price: 19.999)
        expect(product).to_not be_valid
        expect(product.errors[:price]).to include("must have at most two decimal places")
      end
    end
  end
end
