class Project
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :title, :type => String
  field :description, :type => String
  field :address, :type => String
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
  field :tags, :type => Array
  field :slug, :type => String

  embeds_many :stakeholders
  embeds_many :links
  embeds_many :projects_fundings

  has_many :prints
  has_many :documents
  
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
 
 
  MIN_SIMILARITY_THRESHOLD = 0.7
 
  def similar_projects
    all_similar_projects = []
    list_of_candidate_projects = Project.all # to be made more efficient 
    list_of_candidate_projects.each {|candidate_project|
      similarity = calculate_similarity_with candidate_project
      all_similar_projects << candidate_project if similarity > MIN_SIMILARITY_THRESHOLD
    }
    all_similar_projects[0..4]
  end


  def keywords
    # returns a project's keywords, which are basically keywords form the title union with it's tags
    [self.title.split(" ") << self.tags].flatten
    #todo: remove common noise like 'The' or 'A' or 'And' or 'in' from the title since they are not really keywords
  end
  
  def calculate_similarity_with other_project
    other_keywords = other_project.keywords
    similarity = (self.keywords & other_keywords).count.to_f / other_keywords.count
  end
  
end
