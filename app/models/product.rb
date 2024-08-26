class Product < ApplicationRecord
  belongs_to :category
  has_many :product_images, dependent: :destroy 

  validates :name, presence: true, length: { maximum: 255 }
  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :highlights, presence: true
  validates :detailed_description, presence: true
  validates :assured, inclusion: { in: [true, false] }
end
