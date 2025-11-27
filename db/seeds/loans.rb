module Seeds
  class Loans
    def self.seed(count: 5000, clear_existing: false)
      if clear_existing
        puts "Clearing existing loans..."
        Loan.destroy_all
      end

      puts "Creating #{count} fake loans..."

      count.times do |i|
        member = Member.all.sample
        book = Book.includes(:loans).all.sample

        # Skip if no members or books exist
        next unless member && book

        # Start date should be no more than 1 week old
        start_date_earliest = Date.today - 1.week
        start_date = Faker::Date.between(from: start_date_earliest, to: Date.today)

        # Due date must be on or after start date
        due_date = Faker::Date.between(from: start_date, to: start_date + 1.year)

        book_has_active_loan = book.loans.where.not(status: Loan.statuses[:returned]).exists?
        possible_statuses = book_has_active_loan ? %w[returned] : Loan.statuses.keys
        status = possible_statuses.sample

        return_date = if status == "returned"
          Faker::Date.between(from: due_date, to: due_date + 6.months)
        else
          nil
        end
        notes = Faker::Lorem.paragraph(sentence_count: 2..5)
        metadata = {}

        # Build loan attributes hash
        loan_attributes = {
          member: member,
          book: book,
          start_date: start_date,
          due_date: due_date,
          return_date: return_date,
          status: status,
          notes: notes,
          metadata: metadata
        }

        # Create loan with all attributes
        Loan.create!(loan_attributes)

        print "." if (i + 1) % 10 == 0
      end

      puts "\n✅ Successfully created #{count} loans!"
      puts "Total loans in database: #{Loan.count}"
    end
  end
end
