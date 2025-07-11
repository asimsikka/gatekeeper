# require 'securerandom'

# puts "🌱 Clearing existing data..."
# [ParentalConsent, Content, ContentSpace, Membership, Organization, User].each(&:destroy_all)

# puts "👤 Creating users..."
# alice = User.find_or_create_by!(email: "alice@example.com") do |u|
#   u.first_name            = "Alice"
#   u.last_name             = "Admin"
#   u.date_of_birth         = Date.parse("1980-01-01")
#   u.password              = "password"
#   u.password_confirmation = "password"
# end

# bob = User.find_or_create_by!(email: "bob@example.com") do |u|
#   u.first_name            = "Bob"
#   u.last_name             = "Member"
#   u.date_of_birth         = Date.parse("1990-06-15")
#   u.password              = "password"
#   u.password_confirmation = "password"
# end

# charlie = User.find_or_create_by!(email: "charlie@example.com") do |u|
#   u.first_name            = "Charlie"
#   u.last_name             = "Teen"
#   u.date_of_birth         = 15.years.ago.to_date
#   u.password              = "password"
#   u.password_confirmation = "password"
# end

# dana = User.find_or_create_by!(email: "dana@example.com") do |u|
#   u.first_name            = "Dana"
#   u.last_name             = "Child"
#   u.date_of_birth         = 10.years.ago.to_date
#   u.password              = "password"
#   u.password_confirmation = "password"
# end

# puts "✉️  Creating parental consent records..."
# ParentalConsent.find_or_create_by!(user: dana, guardian_email: "parent_pending@example.com")
# ParentalConsent.find_or_create_by!(user: dana, guardian_email: "parent_approved@example.com") do |c|
#   c.approve!
# end

# puts "🏢 Creating organizations..."
# org1 = Organization.find_or_create_by!(name: "Org One") do |o|
#   o.email_domain = "orgone.com"
# end

# org2 = Organization.find_or_create_by!(name: "Org Two") do |o|
#   o.email_domain = "orgtwo.com"
# end

# puts "🔗 Creating active memberships..."
# Membership.find_or_create_by!(organization: org1, user: alice) do |m|
#   m.role   = "admin"
#   m.status = "active"
# end

# Membership.find_or_create_by!(organization: org1, user: bob) do |m|
#   m.role   = "member"
#   m.status = "active"
# end

# Membership.find_or_create_by!(organization: org1, user: charlie) do |m|
#   m.role   = "member"
#   m.status = "active"
# end

# Membership.find_or_create_by!(organization: org2, user: bob) do |m|
#   m.role   = "admin"
#   m.status = "active"
# end

# Membership.find_or_create_by!(organization: org2, user: charlie) do |m|
#   m.role   = "manager"
#   m.status = "active"
# end

# puts "🔔 Creating a pending invite (Org1 → Dana)..."
# Membership.find_or_create_by!(organization: org1, invite_email: dana.email) do |m|
#   m.role              = "member"
#   m.status            = "invited"
#   m.invitation_token  = SecureRandom.urlsafe_base64(24)
#   m.invitation_sent_at = Time.current
# end

# puts "📚 Creating content spaces..."
# teen_zone  = ContentSpace.find_or_create_by!(organization: org1, name: "Teen Zone")  { |s| s.min_age = 13; s.max_age = 17 }
# adult_zone = ContentSpace.find_or_create_by!(organization: org1, name: "Adult Zone") { |s| s.min_age = 18; s.max_age = 99 }
# all_ages   = ContentSpace.find_or_create_by!(organization: org2, name: "All Ages")    { |s| s.min_age = 0;  s.max_age = 99 }

# puts "✍️  Creating contents..."
# Content.find_or_create_by!(content_space: teen_zone, user: charlie, title: "Teen Tips") do |c|
#   c.body       = "Some tips appropriate for ages 13–17."
#   c.age_rating = 15
# end

# Content.find_or_create_by!(content_space: adult_zone, user: alice, title: "Adult Advice") do |c|
#   c.body       = "Advice best suited for 18+ audiences."
#   c.age_rating = 21
# end

# Content.find_or_create_by!(content_space: all_ages, user: bob, title: "Fun for All") do |c|
#   c.body       = "Kid-friendly content everyone can enjoy."
#   c.age_rating = 0
# end

# puts "✅ Seeding complete!"

require 'securerandom'

puts "🌱 Clearing existing data..."
[ParentalConsent, Membership, ContentSpace, Organization, User].each(&:destroy_all)

puts "👤 Creating users..."
alice = User.find_or_create_by!(email: "alice@example.com") do |u|
  u.first_name            = "Alice"
  u.last_name             = "Admin"
  u.date_of_birth         = Date.parse("1980-01-01")
  u.password              = "password"
  u.password_confirmation = "password"
end

bob = User.find_or_create_by!(email: "bob@example.com") do |u|
  u.first_name            = "Bob"
  u.last_name             = "Member"
  u.date_of_birth         = Date.parse("1990-06-15")
  u.password              = "password"
  u.password_confirmation = "password"
end

charlie = User.find_or_create_by!(email: "charlie@example.com") do |u|
  u.first_name            = "Charlie"
  u.last_name             = "Teen"
  u.date_of_birth         = 15.years.ago.to_date
  u.password              = "password"
  u.password_confirmation = "password"
end

dana = User.find_or_create_by!(email: "dana@example.com") do |u|
  u.first_name            = "Dana"
  u.last_name             = "Child"
  u.date_of_birth         = 10.years.ago.to_date
  u.password              = "password"
  u.password_confirmation = "password"
end

puts "✉️  Seeding parental consent for Dana (minor)..."
# Pending consent
ParentalConsent.find_or_create_by!(user: dana, guardian_email: "parent_pending@example.com") do |c|
  # leave approved: false, sent_at auto-set
end
# Already approved consent
ParentalConsent.find_or_create_by!(
  user:           dana,
  guardian_email: "parent_approved@example.com"
) do |c|
  c.approve!   # flips both c.approved and dana.parental_consent
end

puts "🏢 Creating organizations..."
org1 = Organization.find_or_create_by!(name: "Org One") do |o|
  o.email_domain = "orgone.com"
end

org2 = Organization.find_or_create_by!(name: "Org Two") do |o|
  o.email_domain = "orgtwo.com"
end

puts "🔗 Creating active memberships..."
# Org1: Alice=admin, Bob&Charlie=member
Membership.find_or_create_by!(organization: org1, user: alice) do |m|
  m.role   = "admin"
  m.status = "active"
end
Membership.find_or_create_by!(organization: org1, user: bob) do |m|
  m.role   = "member"
  m.status = "active"
end
Membership.find_or_create_by!(organization: org1, user: charlie) do |m|
  m.role   = "member"
  m.status = "active"
end

# Org2: Bob=admin, Charlie=manager
Membership.find_or_create_by!(organization: org2, user: bob) do |m|
  m.role   = "admin"
  m.status = "active"
end
Membership.find_or_create_by!(organization: org2, user: charlie) do |m|
  m.role   = "manager"
  m.status = "active"
end

puts "🔔 Seeding a pending invite (Org1 → Dana)..."
Membership.find_or_create_by!(organization: org1, invite_email: dana.email) do |m|
  m.role               = "member"
  m.status             = "invited"
  m.invitation_token   = SecureRandom.urlsafe_base64(24)
  m.invitation_sent_at = Time.current
end

puts "📚 Creating content spaces..."
ContentSpace.find_or_create_by!(organization: org1, name: "Teen Zone")  do |s|
  s.min_age = 13; s.max_age = 17
end
ContentSpace.find_or_create_by!(organization: org1, name: "Adult Zone") do |s|
  s.min_age = 18; s.max_age = 99
end
ContentSpace.find_or_create_by!(organization: org2, name: "All Ages")   do |s|
  s.min_age = 0;  s.max_age = 99
end

puts "✅ Seeding complete! 🚀"
