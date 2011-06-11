class Link
  include Mongoid::Document
  field :name, :type => String
  field :url, :type => String
  embedded_in :project
end
