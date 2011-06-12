module ApplicationHelper

  def select_if(selection, val)
    "selected" if selection == val
  end

  def select_main_menu_if(first, second)
    "selected" if first == second
  end

end
