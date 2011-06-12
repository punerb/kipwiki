class News
  include Mongoid::Document
  field :content, :type => String
  
  embedded_in :project
end
