module Seeds
  class Loans
    def self.seed(count: 100, clear_existing: false)
      if clear_existing
        puts "Clearing existing loans..."
        Loan.destroy_all
      end

      puts "Creating #{count} fake loans..."

      count.times do |i|
        member = Member.all.sample
        book = Book.all.sample
        start_date = Faker::Date.between(from: 1.year.ago, to: Date.today)
        due_date = Faker::Date.between(from: start_date, to: 1.year.from_now)
        return_date = if rand < 0.7  # 70% chance of being returned
          Faker::Date.between(from: due_date, to: 1.year.from_now)
        else
          nil
        end
        status = Loan.statuses.keys.sample
        notes = Faker::Lorem.paragraph(sentence_count: 2..5)
        metadata = {
          renewal_count: rand(0..3)
        }

        # Generate time values (only time portion)
        paused_start_time = nil
        paused_end_time = nil
        if rand < 0.3  # 30% chance of having paused times
          start_hour = rand(8..16)
          paused_start_time = Time.parse("#{start_hour}:00:00")
          paused_end_time = Time.parse("#{[start_hour + rand(1..4), 23].min}:00:00")
        end

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

        # Only add paused times if they exist
        if paused_start_time && paused_end_time
          loan_attributes[:paused_start_time] = paused_start_time
          loan_attributes[:paused_end_time] = paused_end_time
        end

        # Create loan with all attributes
        Loan.create!(loan_attributes)

        print "." if (i + 1) % 10 == 0
      end

      puts "\n✅ Successfully created #{count} loans!"
      puts "Total loans in database: #{Loan.count}"
    end
  end
end