class Member < ApplicationRecord
  enum :gender, {
    male: 1,
    female: 2,
    prefer_not_to_say: 3
  }

  has_many :loans, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { minimum: 3 }, allow_blank: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :birth_date, presence: true
  validates :birth_date, comparison: { greater_than: Date.new(1900, 1, 1), less_than: Date.today }, allow_blank: true
  validates :gender, presence: true

  # not required
  # validates :is_active, inclusion: { in: [true, false] }
  # validates :is_vip, inclusion: { in: [true, false] }
  # validates :is_admin, inclusion: { in: [true, false] }

  validates :balance, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :total_spent, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :discount_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100.00 }, allow_blank: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :books_borrowed, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :books_returned, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
end
