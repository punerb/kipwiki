class Print < Asset
  has_mongoid_attached_file :attachment,
    :styles => {:medium => "480x480>", 
      :thumb => "100x100>", 
      :slider => "258x193>"},
      :storage => :s3,
      :path => ":attachment/:id/:style/:basename.:extension",
      :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
      :default_url => "/images/missing.png"

  validates_attachment_size :attachment, :less_than => 1.megabytes, :message => 'file size maximum 1 MB allowed'

  validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/gif']
end
