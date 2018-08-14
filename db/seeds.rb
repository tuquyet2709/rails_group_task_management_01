User.create!(name:  "Duclh",
             email: "admin@gmail.com",
             password:              "12345678",
             password_confirmation: "12345678",
             activated: true,
             confirmed_at: "2018-08-16 04:01:29",
             role: 0)
20.times do |n|
  name  = Faker::Name.name
  email = "leader-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               confirmed_at: "2018-08-16 04:01:29",
               activated: true,
               role: 1)
end
10.times do |n|
  name  = Faker::Name.name
  email = "no_leader-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               confirmed_at: "2018-08-16 04:01:29",
               activated: false ,
               role: 1)
end
20.times do |n|
  name  = Faker::Name.name
  email = "member-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               confirmed_at: "2018-08-16 04:01:29",
               activated: true,
               role: 2)
end
member = User.where(role: 2).limit(10)
30.times do
  content = Faker::Lorem.sentence(5)
  member.each { |member| member.reports.create!(content: content) }
end
# Add relationships
members = User.where(role: 2).all
member1  = members.first
following = members[2..50]
followers = members[3..40]
following.each { |followed| member1.follow(followed) }
followers.each { |follower| follower.follow(member1) }
