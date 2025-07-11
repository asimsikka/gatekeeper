# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# org = Organization.find_or_create_by!(name: "Test Org")
# admin = User.find_or_create_by!(email: "admin@example.com") { _1.password = "password" }
# user  = User.find_or_create_by!(email: "user@example.com")  { _1.password = "password" }

# org.memberships.find_or_create_by!(user: admin) { _1.role = :admin }
# org.memberships.find_or_create_by!(user: user)  { _1.role = :member }


puts "🌱 Seeding database with organizations, users, and memberships..."

# Reset data
Membership.delete_all
User.delete_all
Organization.delete_all

# Helper method
def create_user(email:, password:, dob:, parental_consent:, role:, org:)
  user = User.find_or_create_by!(email: email) do |u|
    u.password = password
    u.date_of_birth = dob
    u.parental_consent = parental_consent
  end

  org.memberships.find_or_create_by!(user: user) { _1.role = role }
  user
end

# Create Organizations
org1 = Organization.create!(name: "Alpha Org", description: "First test org", location: "NYC")
org2 = Organization.create!(name: "Beta Org", description: "Second test org", location: "SF")

# Adult Users (18+)
create_user(email: "admin1@alpha.com", password: "password", dob: 30.years.ago, parental_consent: true, role: :admin, org: org1)
create_user(email: "member1@alpha.com", password: "password", dob: 22.years.ago, parental_consent: true, role: :member, org: org1)

create_user(email: "admin2@beta.com", password: "password", dob: 35.years.ago, parental_consent: true, role: :admin, org: org2)
create_user(email: "member1@beta.com", password: "password", dob: 20.years.ago, parental_consent: true, role: :member, org: org2)

# Teen Users (13–17)
create_user(email: "teen1@alpha.com", password: "password", dob: 15.years.ago, parental_consent: true, role: :member, org: org1)
create_user(email: "teen2@beta.com", password: "password", dob: 14.years.ago, parental_consent: true, role: :member, org: org2)

# Minor Users (<13)
create_user(email: "minor1@alpha.com", password: "password", dob: 10.years.ago, parental_consent: false, role: :member, org: org1)
create_user(email: "minor2@beta.com", password: "password", dob: 11.years.ago, parental_consent: true, role: :member, org: org2)

# Cross-org test
shared_user = User.find_or_create_by!(email: "shared@both.com") do |u|
  u.password = "password"
  u.date_of_birth = 28.years.ago
  u.parental_consent = true
end

org1.memberships.find_or_create_by!(user: shared_user) { _1.role = :member }
org2.memberships.find_or_create_by!(user: shared_user) { _1.role = :member }

puts "✅ Seeding complete."
