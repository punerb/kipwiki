class Project
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :title, :type => String
  field :description, :type => String
  field :address, :type => String
  field :view_count, :type => Integer 
  field :vote_count, :type => Integer
  field :coordinates, :type => Array
<<<<<<< HEAD
  field :city, :type => String
  field :state, :type => String
  field :country, :type => String
=======
  field :user_id, :type => String
>>>>>>> 53e422296c3ed7acd266dc58583655775906df24

  
  embeds_many :project_types 
  embeds_many :project_statuses
  embeds_many :tags 
  embeds_many :links

  has_many :project_fundings
  has_many :stakeholders
  embeds_many :prints
  embeds_many :documents
  has_many :prints
  has_many :documents
  belongs_to :user
  has_many :prints

  validates :title, :description, :address, :presence => true

  validates_associated :user

  geocoded_by :address
  after_validation :geocode
  
  after_validation { |project| 
   location =   Geocoder.search(project.address).first 
   if location
     project.city = location.city
     project.country = location.country
     project.state = location.state
   #  project.save
   end
  }
end
