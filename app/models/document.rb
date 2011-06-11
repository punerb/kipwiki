class Document < Asset
  has_mongoid_attached_file :attachment
end
