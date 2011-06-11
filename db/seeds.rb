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
     
   project_types=["Local_project","Property","Suspendissue","Pelentesque"]
   project_statuces=["Initiating","Suspendise","Pelentesque","Unaknoledge"]
   tags=["Temple","Heritage","Worship","Religion"]
   links=["www.github.com","www.moroco.com"] 
   
   user = User.create({:first_name =>"Methun",:last_name => ":Chakraborty", :city => "Pune"  ,:email => "met@gmail.com", :password => "testuser"  })
   puts user.errors
    10.times do |n|
    projects = Project.create({ :title =>"Poject#{n}",
   :address =>[Faker::Address.street_address, Faker::Address.secondary_address, locations[rand(locations.length)]].join(" "),
   :description => Faker::Lorem.sentences(40),
    :project_types => [ {:name =>project_types[rand(4)] }, {:name =>project_types[rand(4)] }  ],
    :project_statuses => [{ :name =>"Initiating" }, {:name => "Unaknowledged"}],
    :tags => [{:name => "Temple" },{:name => "Heritage" } ],
    :links => [ {:name => Faker::Lorem.words(3).join(" "), :url => Faker::Internet.domain_name } ],
    :project_fundings =>[ {:name => "Innovation", :amount => 1111 , :currency => "$" }],
    :stakeholders => [ {:name => Faker::Name.name, :url => Faker::Internet.domain_name } ],
    :user => user
 
     })
	puts projects.errors if projects.errors.present?
	puts "project created no. #{n}" if projects.errors.empty?
   end


 
   # 1..3.each do |x| do
  #  users=User.create([
   # { :first_name => names[rand(names.length)]
  #   ,:last_name => "Chakraborty"
   #  ,:city =>locations[rand(locations.length)] 
    # ,:email =>"mettin.avargin@gmail.com"
 #    ,:password => "sss"}
  #  ])  
  # end
   
