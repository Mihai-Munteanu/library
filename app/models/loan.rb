class Loan < ApplicationRecord
  enum :status, {
    borrowed: 0,
    returned: 1,
    overdue: 2
  }

  belongs_to :member
  belongs_to :book

  validates :start_date, presence: true
  validates :start_date, comparison: { greater_than: Date.new(1900, 1, 1), less_than: Date.today }, allow_blank: true
  validates :due_date, presence: true
  validates :due_date, comparison: { greater_than: :start_date }, allow_blank: true
  validates :return_date, comparison: { greater_than: :start_date }, allow_blank: true
  validates :notes, length: { maximum: 1000 }, allow_blank: true
  validates :metadata, length: { maximum: 1000 }, allow_blank: true

  validates :paused_start_time, comparison: { less_than_or_equal_to: :paused_end_time }, allow_blank: true
  validates :paused_end_time, comparison: { greater_than_or_equal_to: :paused_start_time }, allow_blank: true
end
