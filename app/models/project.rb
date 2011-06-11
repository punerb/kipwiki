class Project
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :title, :type => String
  field :description, :type => String
  field :view_count, :type => Integer 
  field :vote_count, :type => Integer
  field :address, :type => String     # Used for geo-location
  field :city, :type => String        # From Geocoder location
  field :country, :type => String     # From Geocoder location
  field :zip_code, :type => String     # From Geocoder location
  field :coordinates, :type => Array  # For geolocation
  field :categories, :type => Array
  field :status, :type => String
  field :govt_status, :type => String

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
  after_validation :geocode_me

  def geocode_me
    result = Geocoder.search(self.address)
    self.coordinates = result.first.coordinates
    self.city = result.first.city
    self.country = result.first.country
  end
end
