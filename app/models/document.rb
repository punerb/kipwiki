class Document < Asset
  has_mongoid_attached_file :attachment,
    :storage => 's3',
    :bucket => 'docs',
    :s3_credentials => YAML.load_file("#{Rails.root}/config/s3.yml")
end
