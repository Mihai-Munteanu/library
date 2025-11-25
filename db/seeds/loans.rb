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
        book = Book.all.sample

        # Skip if no members or books exist
        next unless member && book

        # start_date must be less than Date.today (not equal), so use Date.yesterday as max
        start_date = Faker::Date.between(from: 1.year.ago, to: Date.yesterday)
        # due_date must be greater than start_date (not equal), so start from start_date + 1 day
        due_date = Faker::Date.between(from: start_date + 1.day, to: 1.year.from_now)
        return_date = if rand < 0.7  # 70% chance of being returned
          # return_date must be greater than start_date, so ensure it's at least due_date
          Faker::Date.between(from: due_date, to: 1.year.from_now)
        else
          nil
        end
        status = Loan.statuses.keys.sample
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
