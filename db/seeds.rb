User.create!(name:  "Duclh",
             email: "admin@gmail.com",
             password:              "12345678",
             password_confirmation: "12345678",
             admin: true,
             activated: true,
             role: 0)
20.times do |n|
  name  = Faker::Name.name
  email = "leader-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               role: 1)
end
100.times do |n|
  name  = Faker::Name.name
  email = "memeber-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               role: 2)
end
member = User.where(role: 2).limit(10)
50.times do
  content = Faker::Lorem.sentence(5)
  member.each { |member| member.reports.create!(content: content) }
end
