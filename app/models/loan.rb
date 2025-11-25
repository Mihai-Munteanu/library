class Loan < ApplicationRecord
  enum :status, {
    borrowed: 0,
    returned: 1,
    overdue: 2
  }

  belongs_to :member
  belongs_to :book

  # Callbacks to update book status when loan changes
  after_save :update_book_status
  after_destroy :update_book_status

  validates :start_date, presence: true
  validates :start_date, comparison: { greater_than_or_equal_to: Date.today }, allow_blank: true, on: :create
  validates :due_date, presence: true
  validates :due_date, comparison: { greater_than: :start_date }, allow_blank: true
  validates :return_date, comparison: { greater_than: :start_date }, allow_blank: true
  validates :notes, length: { maximum: 1000 }, allow_blank: true
  validates :metadata, length: { maximum: 1000 }, allow_blank: true

  private

  def update_book_status
    book.update_status_from_loans
  end
end
