class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true
  validates :title, length: { minimum: 3 }, allow_blank: true
  validates :isbn, presence: true
  validates :isbn, length: { minimum: 10 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :publication_date, presence: true
  validates :publication_date, comparison: { less_than: Date.today }, allow_blank: true
  validates :copies_sold, presence: true
  validates :copies_sold, numericality: { greater_or_equal_to: 0 }
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }, allow_blank: true
  validates :pages, numericality: { greater_or_equal_to: 0 }
end
