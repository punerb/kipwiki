module ProjectsHelper

  def edit_link(project, field_type)
    if user_signed_in?
      if project.user == current_user
        link_to "Edit", edit_project_path(project.city, project.slug, :type=> field_type)
      else
        link_to "Suggest", "#", :class => "edit", :rel => field_type, :name => field_type
      end
    else
      link_to "Suggest", authentications_path, :name => field_type
    end
  end

end
