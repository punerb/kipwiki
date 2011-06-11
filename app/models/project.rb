class Project
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :title, :type => String
  field :description, :type => String
  field :address, :type => String
  field :view_count, :type => Integer 
  field :vote_count, :type => Integer
  field :coordinates, :type => Array
  field :user_id, :type => String

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


  validates :title, :description, :address, :presence => true

  validates_associated :user

  geocoded_by :address
  after_validation :geocode
end
