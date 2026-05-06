# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "benchmark"

puts "Seeding employees..."

first_names = File.readlines(Rails.root.join("db/seeds/first_names.txt"), chomp: true)
last_names  = File.readlines(Rails.root.join("db/seeds/last_names.txt"), chomp: true)

job_titles = ["Engineer", "Manager", "Analyst", "HR", "Designer"]
countries  = ["India", "USA", "UK", "Canada", "Germany"]

batch_size = 1000
total = 10_000

records = []

total.times do
records << {
  full_name: "#{first_names.sample} #{last_names.sample}",
  job_title: job_titles.sample,
  country: countries.sample,
  salary: rand(30_000..150_000),
  created_at: Time.current,
  updated_at: Time.current
}

# Insert in batches
if records.size >= batch_size
  Employee.insert_all(records)
  records.clear
end
end

# Insert remaining
Employee.insert_all(records) if records.any?
