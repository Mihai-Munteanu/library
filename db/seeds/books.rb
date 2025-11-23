# Book Seeder
# Creates fake books for development and testing

module Seeds
  class Books
    def self.seed(count: 5000, clear_existing: false)
      # Clear existing books if requested
      if clear_existing
        puts "Clearing existing books..."
        Book.destroy_all
      end

      puts "Creating #{count} fake books..."

      count.times do |i|
        # Generate publication date between 1900 and 2000
        publication_date = Faker::Date.between(from: Date.new(1900, 1, 1), to: Date.new(2000, 12, 31))

        # Build book attributes hash
        book_attributes = {
          title: Faker::Book.title,
          isbn: Faker::Code.isbn,
          description: Faker::Lorem.paragraph(sentence_count: 3..8),
          publication_date: publication_date,
          copies_sold: Faker::Number.between(from: 0, to: 100000),
          price: Faker::Number.between(from: 0.00, to: 100.00),
          pages: Faker::Number.between(from: 0, to: 1000),
          author_id: Author.all.sample.id
        }

        # Create book with all attributes
        Book.create!(book_attributes)

        print "." if (i + 1) % 10 == 0
      end
    end
  end
end
