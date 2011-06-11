class Project
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :title, :type => String
  field :description, :type => String
  field :view_count, :type => Integer 
  field :vote_count, :type => Integer
  field :address, :type => String     # Used for geo-location
  field :city, :type => String        # From Geocoder location
  field :state, :type => String
  field :country, :type => String     # From Geocoder location
  field :zip_code, :type => String     # From Geocoder location
  field :coordinates, :type => Array  # For geolocation
  field :categories, :type => Array
  field :status, :type => String
  field :govt_status, :type => String
  field :slug, :type => String
  embeds_many :stakeholders
  embeds_many :links
  embeds_many :projects_fundings

  has_many :prints
  has_many :documents
  has_and_belongs_to_many :tags

  belongs_to :user

  validates :title, :description, :address, :presence => true
  validates_associated :user

  geocoded_by :address
  
  after_validation { |project| 
   location =   Geocoder.search(project.address).first 
   if location
     project.coordinates = location.coordinates
     project.city = location.city
     project.country = location.country
     project.state = location.state
   end
  }
  
  before_create { |project|
   project.slug = project.title.parameterize
  }
 
end
