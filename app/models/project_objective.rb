class ProjectObjective
  include Mongoid::Document
  field :name, :type => String
  field :objective_id
  belongs_to :project
  has_many :sub_objectives, :class => :project_objective, :throught => :objective_id
end
