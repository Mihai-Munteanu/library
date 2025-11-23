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
        gender = Author.genders.values.sample
        metadata = {
          website: Faker::Internet.url,
          email: Faker::Internet.email,
          twitter: Faker::Internet.username,
          facebook: Faker::Internet.username,
          tags: Faker::Lorem.words(number: rand(1..5)),
          notes: Faker::Lorem.paragraph(sentence_count: 2..5)
        }

        # Build author attributes hash
        author_attributes = {
          name: Faker::Name.name,
          biography: Faker::Lorem.paragraph(sentence_count: 3..8),
          birth_date: birth_date,
          death_date: death_date,
          nationality: Faker::Address.country,
          gender: gender,
          metadata: metadata
        }

        # Create author with all attributes
        Author.create!(author_attributes)

        print "." if (i + 1) % 10 == 0
      end

      puts "\n✅ Successfully created #{count} authors!"
      puts "Total authors in database: #{Author.count}"
    end
  end
end
