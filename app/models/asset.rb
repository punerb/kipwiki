class Asset
  include Mongoid::Document
  include Mongoid::Paperclip
  field :project_id, :type => Integer

  belongs_to :project
end
