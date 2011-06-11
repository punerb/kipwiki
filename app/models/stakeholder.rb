class Stakeholder
  include Mongoid::Document
  field :name, :type => String
  field :url, :type => String
  field :key, :type => Boolean

  embedded_in :project
end
