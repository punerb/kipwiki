class Project
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :title, :type => String
  field :description, :type => String
  field :address, :type => String
  field :view_count, :type => Integer 
  field :vote_count, :type => Integer #currently we're not using it since fb_like is implemented instead
  field :city, :type => String        # From Geocoder location
  field :state, :type => String
  field :country, :type => String     # From Geocoder location
  field :zip_code, :type => String     # From Geocoder location
  field :categories, :type => Array
  field :status, :type => String, :default => 'Initiation'   
  field :govt_status, :type => String
  field :tags, :type => Array
  field :slug, :type => String
  field :caption, :type => String
  field :project_scope, :type => String, :default => 'Local'
  field :featured, :type => Boolean, :default => false
  field :tagline, :type => String
  field :manager, :type => String
  field :sponsor, :type => String
  field :cost, :type => String
  field :period, :type => String

  embeds_many :stakeholders
  embeds_many :links
  embeds_many :project_fundings
  embeds_many :news  
  embeds_many :activities

  has_many :project_objectives
  has_many :prints
  has_many :documents
  has_many :suggestions
  has_many :followed_projects

  belongs_to :user

  validates :description, :address, :presence => true
  validates :title, :presence => true , :length => {:maximum => 50}
  validates_associated :user

  field :coordinates, :type => Array  # For geolocation
  geocoded_by :address
  
  before_validation { |project| 
   location = Geocoder.search(project.address).first 
   if location and not (location.city.empty? or location.country.empty?)
     project.coordinates = location.coordinates
     project.city = location.city.parameterize.titleize
     project.country = location.country.parameterize.titleize
     project.state = location.state.parameterize.titleize
   else
     self.errors[:address] = 'cannot be verified'
   end
  }
  
  before_create { |project|
   project.slug = project.title.parameterize
  }
  
  before_save {
    return if new_record?
    if changed?
      changes.each_pair { |k, v|
        next if k.to_s == 'view_count'
        begin
          self.activities.create(:text => "#{k.humanize} was changed.", :user => self.user)
        rescue Exception => err
        end
      }
    end
  }
  
  def project_completion
    # works by adding up weighted scores for the presence of content in a number of select fields
    # since there are compulsory_fields title, description, location, we never start with 0% :-p
    # at times, or in the future, a category might not exist, which is why we architected this code with total and cumulative_value, instead of a straightforward 1 dimensional number
    # ToDo: this code is a bit redundant...
    # the weighting can be changed by just changing the numbers
    completion_parameters_and_weightages = [
      {:status => 10},
      {:categories => 10},
      {:project_fundings => 10},
      {:stakeholders => 10},
      {:project_objectives => 20},
      {:prints => 20},
      {:documents => 10},
      {:links => 5}
    ]
    #initial value
    completion_scores = {:cumulative_value => 10, :total => 10}

    completion_parameters_and_weightages.each do |config|
      unless self.send(config.keys.first).nil?
        completion_scores[:total] += config.values.first
        completion_scores[:cumulative_value] += config.values.first unless self.send(config.keys.first).empty?
      end
    end

    completion_score = (100   * completion_scores[:cumulative_value].to_f / completion_scores[:total].to_f).round
  end
 
  MIN_SIMILARITY_THRESHOLD = 0.2 
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
