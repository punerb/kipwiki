class ProjectObjective
  include Mongoid::Document
  field :name, :type => String
  field :priority, :type => String
  field :project_id, :type => Integer
  field :sub_project_objectives, :type => Array


  belongs_to :project

#  embeds_many :sub_project_objectives
#
#  accepts_nested_attributes_for :sub_project_objectives
end
