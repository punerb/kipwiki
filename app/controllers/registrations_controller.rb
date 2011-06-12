class RegistrationsController < Devise::RegistrationsController

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
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
