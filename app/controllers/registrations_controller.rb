class RegistrationsController < Devise::RegistrationsController

  layout "home_layout"

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
    flash[:notice] = 'You have signed up successfully. Please check your email to complete registration process'
  end
  
  def edit
    respond_to do |format|
      format.html {render :layout => 'admin' }# edit.html.erb
      format.xml  { render :xml => @user }
    end
  end

  private
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

end
