class ProjectStatus
  include Mongoid::Document
  field :name, :type => String
  embedded_in :project
end
