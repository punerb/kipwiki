class ProjectObjective
  include Mongoid::Document
  field :name, :type => String
  field :objective_id
  belongs_to :project

  belongs_to :project_objective, :class => 'ProjectObjective'
  has_many :sub_objectives, :class_name => 'ProjectObjective', :foreign_key => 'objective_id'
end
