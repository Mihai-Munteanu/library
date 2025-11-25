# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Load all seed files from db/seeds directory
Dir[Rails.root.join("db/seeds/*.rb")].sort.each { |file| require file }

# Seed authors
# Set clear_existing: true if you want to delete all existing authors first
Seeds::Authors.seed(count: 30, clear_existing: false)

# Seed books
Seeds::Books.seed(count: 500, clear_existing: false)

# Seed members
Seeds::Members.seed(count: 30, clear_existing: false)

# Seed loans
Seeds::Loans.seed(count: 5000, clear_existing: false)
