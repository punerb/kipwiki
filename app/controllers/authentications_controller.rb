class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.xml
  layout "home_layout"
  def index
    @authentications = Authentication.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authentications }
    end
  end

  # GET /authentications/new
  # GET /authentications/new.xml
  def new
    @authentication = Authentication.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @authentication }
    end
  end

  # POST /authentications
  # POST /authentications.xml
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first

    if authentication
      user = authentication.user
      sign_in_and_redirect(:user, user)

    elsif omniauth["user_info"]["email"].present?
      ##handle facebook-email signup with email here..
      user = User.where(:email => omniauth["user_info"]["email"]).first
      if user
        user.authentications.create!(:provider => omniauth["provider"], :uid => omniauth["uid"])
        flash[:notice] = "Sign in Successful."
        sign_in_and_redirect(:user, user)
      end

    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to root_url

    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed Up successfully."
        sign_in_and_redirect(:user, user)
      else
        flash[:notice] = "Please fill in these details to complete the registration."
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
      logger.info("no current_user case here.... ")
    end
  end

# DELETE /authentications/1
# DELETE /authentications/1.xml
  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to(authentications_url) }
      format.xml  { head :ok }
    end
  end

  def failure

  end
end
