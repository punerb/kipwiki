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
  field :caption, :type => String

  embeds_many :stakeholders
  embeds_many :links
  embeds_many :projects_fundings

  has_many :prints
  has_many :documents
  
  belongs_to :user

  #validates :title, :description, :address, :presence => true
  #validates_associated :user

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
   length = Project.where(:city => project.city, :slug => project.slug).length 
   project.slug << "-#{length+1}" if length > 0
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
    all_similar_projects.sort{|b,a| a[:s] <=> b[:s]}[0..4].collect{|proj| proj[:p]} #.collect{|p| p.tags}
  end

  def keywords
    # returns a project's keywords, which are basically keywords form the title union with it's tags
    [self.title.split(" ") << self.tags].flatten.uniq
    #todo: remove common noise like 'The' or 'A' or 'And' or 'in' from the title since they are not really keywords
    #todo: need to sanitize the keywords so that they are all lowercase as well
  end
  
  def calculate_similarity_with other_project
    other_keywords = other_project.keywords #will never be zero since the title is compulsory so the number of keywords is always at least 1
    similarity = (self.keywords & other_keywords).count.to_f / other_keywords.count
  end
  
end
