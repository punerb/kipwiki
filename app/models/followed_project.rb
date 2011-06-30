class FollowedProject
  include Mongoid::Document
  
  belongs_to :user
  belongs_to :project  

 
end
