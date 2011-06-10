class Project
  include Mongoid::Document

  belongs_to :user
end
