class ViewManager

  def initialize io_handler, menu_views, view_prompts
    @io_handler = io_handler
    @menu_views = menu_views
    @view_prompts = view_prompts
  end

  def get_prompt prompt
    @io_handler.print(@view_prompts.get_prompt(prompt))
  end

  def get_view view
    @io_handler.print(@menu_views.get_view(view))
  end

  def get_parameter_view view, parameter
    @io_handler.print(@menu_views.get_parameter_view(view, parameter))
  end

  def get_input
    @io_handler.get_input
  end

  def clear_view
    system "clear"
  end

  def start_view
    clear_view
    @io_handler.print(@menu_views.get_view(:welcome_view))
    @io_handler.print(@view_prompts.get_prompt(:request_name))
  end

  def invalid_name_view
    clear_view
    @io_handler.print(@view_prompts.get_prompt(:not_employee))
  end

  def log_time_view
    clear_view
    @io_handler.print(@menu_views.get_view(:time_entry_view))
    @io_handler.print(@view_prompts.get_prompt(:request_time_entry))
  end

end
