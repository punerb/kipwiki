module ApplicationHelper

  def select_if(selection, val)
    "selected" if selection == val
  end
end
