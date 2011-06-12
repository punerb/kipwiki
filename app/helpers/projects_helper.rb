module ProjectsHelper

  def edit_link(field_type)
    if user_signed_in?
      link_to "Edit", "#", :class => "edit", :rel => field_type
    else
      link_to "Edit", authentications_path
    end
  end
end
