# Member Seeder
# Creates fake members for development and testing

module Seeds
  class Members
    def self.seed(count: 100, clear_existing: false)
      # Clear existing books if requested
      if clear_existing
        puts "Clearing existing members..."
        Member.destroy_all
      end

      puts "Creating #{count} fake members..."

      count.times do |i|
        # Generate publication date between 1900 and 2000
        birth_date = Faker::Date.between(from: Date.new(1900, 1, 1), to: Date.new(2000, 12, 31))

        # Build member attributes hash
        member_attributes = {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          birth_date: birth_date,
          gender: Member.genders.values.sample,
          is_active: [true, false].sample,
          is_vip: [true, false].sample,
          is_admin: [true, false].sample,
          balance: Faker::Number.between(from: 0.00, to: 1000.00),
          total_spent: Faker::Number.between(from: 0.00, to: 1000.00),
          discount_rate: Faker::Number.between(from: 0.00, to: 100.00),
          points: Faker::Number.between(from: 0, to: 1000),
          books_borrowed: Faker::Number.between(from: 0, to: 1000),
          books_returned: Faker::Number.between(from: 0, to: 1000)
        }

        # Create member with all attributes
        Member.create!(member_attributes)

        print "." if (i + 1) % 10 == 0
      end
    end
  end
end
