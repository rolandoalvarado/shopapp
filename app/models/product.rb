class Product < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  validates_presence_of :code, :name, :price
  validates :code, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  validate :price_decimal_limit

  private

  def price_decimal_limit
    if price.present? && price.to_d.round(2) != price.to_d
      errors.add(:price, "must have at most two decimal places")
    end
  end
end
