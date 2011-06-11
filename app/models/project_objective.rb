class ProjectObjective
  include Mongoid::Document
  field :name, :type => String
  field :objective_id
  belongs_to :project
  has_one :sub_objective , :class => :project_objective
end
