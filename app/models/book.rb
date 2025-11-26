class Book < ApplicationRecord
  belongs_to :author
  has_many :loans, dependent: :destroy
  has_one_attached :cover

  # Explicitly declare the attribute type for the enum
  attribute :status, :integer, default: 0

  enum :status, {
    available: 0,
    on_loan: 1
  }

  before_validation :trim_isbn

  validates :title, presence: true
  validates :title, length: { minimum: 3 }, allow_blank: true
  validates :isbn, presence: true
  validates :isbn, length: { minimum: 10 }, allow_blank: true, uniqueness: true
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :publication_date, presence: true
  validates :publication_date, comparison: { less_than: Date.today }, allow_blank: true
  validates :copies_sold, presence: true
  validates :copies_sold, numericality: { greater_or_equal_to: 0 }
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }, allow_blank: true
  validates :pages, numericality: { greater_or_equal_to: 0 }

  # Get the current active loan (if any)
  def current_loan
    loans.where(status: :borrowed).order(created_at: :desc).first
  end

  # Get the member who currently has the book (if on loan)
  def current_borrower
    current_loan&.member
  end

  # Update status based on current loans
  def update_status_from_loans
    if loans.where(status: :borrowed).exists?
      update_column(:status, :on_loan) unless status == "on_loan"
    else
      update_column(:status, :available) unless status == "available"
    end
  end

  private

  def trim_isbn
    self.isbn = isbn&.strip
  end
end
