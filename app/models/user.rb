class User
  include Mongoid::Document
  field :first_name, :type => String
  field :last_name, :type => String
  field :city, :type => String
  field :slug, :type => String
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :projects
  references_many :authentications, :autosave => true


  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    self.first_name = omniauth["user_info"]["name"].split(" ").first if first_name.blank?
    self.last_name = omniauth["user_info"]["name"].split(" ").last if last_name.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  before_create { |user|
    user.slug = "#{user.first_name} #{user.last_name}".parameterize
  }
end
