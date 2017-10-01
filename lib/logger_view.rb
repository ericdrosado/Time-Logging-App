class LoggerView

  def initialize io_handler, prompter
    @io_handler = io_handler
    @prompter = prompter
  end

  def get_prompt prompt
    @io_handler.print(@prompter.get_prompt(prompt))
  end

  def print_view view
    view = send(view)
    @io_handler.print(view)
  end

  def print_parameter_view view, parameter
    view = send(view, parameter)
    @io_handler.print(view)
  end

  def get_input
    @io_handler.get_input
  end

  def clear_view
    system "clear"
  end

  private

  def welcome_view
    "+----------------------------------------------------------------+\n"+
    "|                      Welcome to Time Logger                    |\n"
  end

  def employee_options_view
    "+----------------------------------------------------------------------------------+\n"+
    "|                                  Options Menu                                    |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Please type the number corresponding to the option you would like and press enter|\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "|0. Log Out                                                                        |\n"+
    "|1. Enter Time                                                                     |\n"+
    "|2. Get Time Report                                                                |\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def admin_options_view
    "+----------------------------------------------------------------------------------+\n"+
    "|                              Admin Options Menu                                  |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Please type the number corresponding to the option you would like and press enter|\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "|0. Log Out                                                                        |\n"+
    "|1. Enter Time                                                                     |\n"+
    "|2. Get Time Report                                                                |\n"+
    "|3. Add Employee                                                                   |\n"+
    "|4. Add Client                                                                     |\n"+
    "|5. Get Employees Time Report                                                      |\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def time_entry_view
    "+----------------------------------------------------------------+\n"+
    "|                           Time Entry                           |\n"
  end

  def client_view
    "+----------------------------------------------------------------------------------+\n"+
    "|                                  Client List                                     |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Please type the name of the client you completed Billable Work for:              |\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def client_list_view parameter
    " #{parameter}\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def timecode_report_view parameter
    "+----------------------------------------------------------------------------------+\n"+
    "|                               Timecode Report                                    |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Below is your timecode report for the current month:                             |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "#{parameter}\n"
  end

  def client_report_view parameter
    "+----------------------------------------------------------------------------------+\n"+
    "|                               Client Report                                      |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Below is your client report for the current month:                               |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "#{parameter}\n"
  end

  def detailed_report_view parameter
    "+----------------------------------------------------------------------------------+\n"+
    "|                               Detailed Report                                    |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Below is your detailed report for the current month:                             |\n"+
    "| Key: Date, Hours, Timecode, Client (If applicable)                               |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "#{parameter}\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Please select an option from the menu above to continue.                         |\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def add_employee_view
    "+----------------------------------------------------------------------------------+\n"+
    "|                              Add New Employee                                    |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Please type the name of your new employee with a space between the first and last|\n"+
    "| name. ex.(John Smith)                                                            |\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

end
