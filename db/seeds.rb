# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#create a main sample user
User.create!(first_name: "Example",
             last_name: "User",
            email: "example@friendly.com",
            password: "password",
        password_confirmation: "password",
        admin: true)

        #generate a bunch of additional users
        50.times do |n|
            first_name = Faker::Name.first_name
            last_name = Faker::Name.last_name 
            email = "example-#{n+1}@friendly.com"
            password = "password"
            User.create!(first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password)
        end 

        #generate microposts
        users = User.order(:created_at).take(10)
        50.times do 
            content = Faker::Lorem.sentence(word_count: 10)
            users.each { |user| user.microposts.create!(content: content) }
        end 

        #create following relationships
        users = User.all 
        user = users.first 
        following = users[2..50]
        followers = users[3..40]
        followers.each { |followed| user.follow(followed) }
        followers.each { |follower| follower.follow(user) }
