class HomeController < ApplicationController
  def index
    @projects = Project.all
  end

end
