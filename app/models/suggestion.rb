class Suggestion
  include Mongoid::Document
  belongs_to :project

  field :project_id, :type => Integer
  field :kind, :type => String
  field :text, :type => String
end
