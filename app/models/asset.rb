class Asset
  include Mongoid::Document
  field :project_id, :type => Integer
  field :attachment_file_name, :type => String
  field :attachment_content_type, :type => String
  field :attachment_file_size, :type => Integer

  belongs_to :project
end
