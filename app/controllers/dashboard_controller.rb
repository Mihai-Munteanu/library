class DashboardController < ApplicationController
  def index
    @total_books = Book.count
    @active_loans = Loan.where.not(status: :returned).count
    @overdue_loans = Loan.overdue.count
    @total_members = Member.count
    @total_authors = Author.count
  end
end
