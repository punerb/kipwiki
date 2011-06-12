class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :text, :type => String
  field :user
end
