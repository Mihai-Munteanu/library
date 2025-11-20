# Author Seeder
# Creates fake authors for development and testing

module Seeds
  class Authors
    def self.seed(count: 100, clear_existing: false)
      # Clear existing authors if requested
      if clear_existing
        puts "Clearing existing authors..."
        Author.destroy_all
      end

      puts "Creating #{count} fake authors..."

      count.times do |i|
        # Generate birth date between 1900 and 2000
        birth_date = Faker::Date.between(from: Date.new(1900, 1, 1), to: Date.new(2000, 12, 31))

        # Randomly decide if author is deceased (30% chance)
        is_deceased = rand < 0.3
        death_date = if is_deceased
          # Death date between birth_date and today
          Faker::Date.between(from: birth_date + 1.year, to: Date.today)
        else
          nil
        end

        # Generate gender
        gender = Author.genders.keys.sample

        # Build author attributes hash
        author_attributes = {
          name: Faker::Name.name,
          biography: Faker::Lorem.paragraph(sentence_count: 3..8),
          birth_date: birth_date,
          death_date: death_date,
          nationality: Faker::Address.country,
          gender: gender
        }

        # Conditionally add awards (40% chance)
        if rand < 0.4
          author_attributes[:awards] = Array.new(rand(1..4)) do
            {
              name: Faker::Book.title,
              year: Faker::Number.between(from: 1950, to: 2024).to_s,
              description: Faker::Lorem.sentence
            }
          end.compact
        end

        # Conditionally add publications (50% chance)
        if rand < 0.5
          author_attributes[:publications] = Array.new(rand(1..4)) do
            {
              title: Faker::Book.title,
              publication_date: Faker::Date.between(from: birth_date + 20.years, to: death_date || Date.today).to_s
            }
          end.compact
        end

        # Conditionally add achievements (30% chance)
        if rand < 0.3
          author_attributes[:achievements] = Array.new(rand(1..4)) do
            {
              name: Faker::Job.title,
              year: Faker::Number.between(from: 1950, to: 2024).to_s,
              description: Faker::Lorem.sentence
            }
          end.compact
        end

        # Create author with all attributes
        author = Author.create!(author_attributes)

        print "." if (i + 1) % 10 == 0
      end

      puts "\n✅ Successfully created #{count} authors!"
      puts "Total authors in database: #{Author.count}"
    end
  end
end

