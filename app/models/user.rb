class User
  include Mongoid::Document

  field :first_name, :type => String
  field :last_name, :type => String
  field :city, :type => String

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

end
