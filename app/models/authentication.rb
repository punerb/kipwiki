class Authentication
  include Mongoid::Document

  field :user_id
  field :provider, :type => String
  field :uid, :type => String

  referenced_in :user
end
