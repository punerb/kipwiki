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

begin
  user = User.create({:first_name =>"Methun",:last_name => ":Chakraborty", :city => "Pune"  ,:email => "met@gmail.com", :password => "testuser"  })
  puts user.errors
  10.times do |n|
    projects = Project.create!({ 
      :title =>"Poject#{n}",
      :address =>[Faker::Address.street_address, Faker::Address.secondary_address, locations[rand(locations.length)]].join(" "),
      :description => Faker::Lorem.sentences(10),
      :categories => [ APP_CONFIG[:categories][rand(4)], APP_CONFIG[:categories][rand(4)] ],
      :status => APP_CONFIG[:statuses][rand(4)],
      :project_scope => APP_CONFIG[:project_scopes][rand(4)], 
      :tags => [tags[rand(4)], tags[rand(4)], tags[rand(4)]],
      :links => [ {:name => Faker::Lorem.words(3).join(" "), :url => Faker::Internet.domain_name } ],
      :project_fundings =>[ {:name => "Innovation", :amount => 1111 , :currency => "$" }],
      :stakeholders => [ {:name => Faker::Name.name, :url => Faker::Internet.domain_name } ],
      :user => user
   })
  end
rescue Exception => ex
  puts ex
end