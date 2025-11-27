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
  validates :start_date, comparison: { greater_than_or_equal_to: -> { Date.today - 1.week } }, allow_blank: true
  validates :due_date, presence: true
  validates :due_date, comparison: { greater_than_or_equal_to: :start_date }, allow_blank: true
  validates :return_date, comparison: { greater_than: :start_date }, allow_blank: true
  validates :notes, length: { maximum: 1000 }, allow_blank: true
  validates :metadata, length: { maximum: 1000 }, allow_blank: true
  validate :single_active_loan_per_book, if: -> { book_id.present? && status != "returned" }

  private

  def update_book_status
    book.update_status_from_loans
  end

  def single_active_loan_per_book
    return unless book.loans.where.not(id: id).where.not(status: Loan.statuses[:returned]).exists?

    errors.add(:book, "already has an active loan. Return the current loan before creating another.")
  end
end
