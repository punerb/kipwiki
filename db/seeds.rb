# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# E:xamples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
include Faker
locations=["Pune","Mumbai","Delhi","Goregaon"]
names= ["Mettin", "Chattin" ,"Methun" ]

tags=["Temple","Heritage","Worship","Religion"]
links=["www.github.com","www.moroco.com"]

user = User.create({:first_name =>"Methun",:last_name => ":Chakraborty", :city => "Pune"  ,:email => "met@gmail.com", :password => "testuser"  })

10.times do |n|
  projects = Project.create({
    :title => Faker::Lorem.words(6).join(" "),
    :city => locations.shuffle.first,
    :address =>[ Faker::Address.street_address, Faker::Address.secondary_address, locations[rand(locations.length)]].join(" "),
    :description => Faker::Lorem.sentences(10),
    :categories => [
        APP_CONFIG[:categories][rand(4)], APP_CONFIG[:categories][rand(4)]
    ],
    :status => APP_CONFIG[:statuses][rand(4)],
    :project_scope => APP_CONFIG[:project_scopes][rand(4)],
    :tags => tags.shuffle.take(rand(tags.count)),
    :links => rand(5).times.map{{:name => Faker::Lorem.words(3).join(" "), :url => Faker::Internet.domain_name }},
    :project_fundings =>rand(6).times.map{{:name => Faker::Lorem.words(3).join(" "), :amount => 5000-rand(2000).to_i, :currency => "$" }},
    :project_objectives => rand(5).times.map{{:name => Faker::Lorem.words(2).join(" ")}},
    :stakeholders => rand(5).times.map{{:name => Faker::Name.name, :url => Faker::Internet.domain_name }},
    :user => User.last
  })
  puts "Added Project #{n}"
  puts "Error adding project : #{projects.errors}" if projects.errors.present?
end

