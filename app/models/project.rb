class Project
  include Mongoid::Document
  extend Mongoid::Geo::Near

  field :title, :type => String
  field :description, :type => String
  field :address, :type => String
  field :view_count, :type => Integer 
  field :vote_count, :type => Integer
  field :city, :type => String        # From Geocoder location
  field :state, :type => String
  field :country, :type => String     # From Geocoder location
  field :zip_code, :type => String     # From Geocoder location
  field :categories, :type => Array
  field :status, :type => String
  field :govt_status, :type => String
  field :tags, :type => Array
  field :slug, :type => String
  field :caption, :type => String
  field :project_scope, :type => String

  embeds_many :stakeholders
  embeds_many :links
  embeds_many :projects_fundings

  has_many :prints
  has_many :documents
  
  belongs_to :user

  validates :title, :description, :address, :presence => true
  validates_associated :user

  field :coordinates, :type => Array  # For geolocation
  geo_index :coordinates
  
  after_validation { |project| 
   location =   Geocoder.search(project.address).first 
   if location
     project.coordinates = location.coordinates
     project.city = location.city.titleize
     project.country = location.country.titleize
     project.state = location.state.titleize
   end
  }
  
  before_create { |project|
   project.slug = project.title.parameterize
  }
 
 
  MIN_SIMILARITY_THRESHOLD = 0.5
 
  def similar_projects
    all_similar_projects = []
    list_of_candidate_projects = Project.all # to be made more efficient 
    list_of_candidate_projects.each {|candidate_project|
      unless candidate_project == self
        similarity = calculate_similarity_with candidate_project
        all_similar_projects << {:p => candidate_project, :s => similarity} if similarity > MIN_SIMILARITY_THRESHOLD
      end
    }
    #take the top 5 similar projects
    all_similar_projects.sort{|b,a| a[:s] <=> b[:s]}[0..4].collect{|proj| proj[:p]} 
  end

  def keywords
    # returns a project's keywords, which are basically keywords form the title union with it's tags
    fillers = "a|the|this|that|is|are|was|or|of|here|there|thus|hence|therefore"
    words = [self.title.downcase.gsub(/(^|\s)\d*(\s|$)|#{fillers}/,"").split(" ") << self.tags].flatten.uniq.compact
    #words << self.city
    #words << self.state
    #words << self.country
    #words << self.zip_code
    #words.flatten.uniq.compact
    #todo: need to sanitize the keywords so that they are all lowercase as well
    
  end
  
  private
  
  def calculate_similarity_with other_project
    other_keywords = other_project.keywords #will never be zero since the title is compulsory so the number of keywords is always at least 1
    similarity = (self.keywords & other_keywords).count.to_f / other_keywords.count.to_f

    #0.01 is an arbitrary value, to differentiate between two similarities which are each 100%. This way, two similarities of 100%, where one overlaps 3 times and the other one 7 times, gives the 7-time-overlap scenario a higher similarity rating over the 3-time-overlap scenario
    #similarity = similarity + 0.01*other_keywords.count.to_f if similarity == 1.0 
  end
  
end
