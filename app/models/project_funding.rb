class ProjectFunding
  include Mongoid::Document
  field :name, :type => String
  field :amount, :type => Float
  field :currency, :type => String
  belongs_to :project
end
