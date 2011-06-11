#require 'oa-oauth'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'LzS9jtRteW01Hbf0LLg', 'JuRLUGJDwD1itTmHnXjeRbn65Dt0KnoTKnW0DmJA8'

  #
  #client application specified here as to remove probs over ubutnu+passenger... may be needed to chagne this.
  #detail can be found here - https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  #
  provider :facebook, '220219081330401', '51e546581d706dbff649a8bd067d0720', { :client_options => { :ssl => { :ca_path => "/etc/ssl/certs"} } }

end