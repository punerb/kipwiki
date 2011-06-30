class Suggestion
  include Mongoid::Document
  belongs_to :project
  belongs_to :user

  field :project_id, :type => Integer
  field :user_id, :type => Integer
  field :field_name, :type => String
  field :text, :type => String
  field :is_viewed, :type => Boolean, :default => false
end
