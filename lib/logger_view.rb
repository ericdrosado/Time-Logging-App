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

  def client_list_view client
    " #{client}\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def timecode_report_view timecode_logs
    "+----------------------------------------------------------------------------------+\n"+
    "|                               Timecode Report                                    |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Below is your timecode report for the current month:                             |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "#{timecode_logs}\n"
  end

  def client_report_view client_logs
    "+----------------------------------------------------------------------------------+\n"+
    "|                               Client Report                                      |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Below is your client report for the current month:                               |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "#{client_logs}\n"
  end

  def detailed_report_view logs
    "+----------------------------------------------------------------------------------+\n"+
    "|                               Detailed Report                                    |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Below is your detailed report for the current month:                             |\n"+
    "| Key: Date, Hours, Timecode, Client (If applicable)                               |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "#{logs}\n"+
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

  def add_client_view
    "+----------------------------------------------------------------------------------+\n"+
    "|                               Add New Client                                     |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Please type the name of your new client.                                         |\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def employee_summary_report
    "+----------------------------------------------------------------------------------+\n"+
    "|                                Summary Report                                    |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "| Below is a summary of last months hours:                                         |\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def employee_name_view name
    "+----------------------------------------------------------------------------------+\n"+
    " #{name} Summary Report\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def employee_timecode_summary_report timecode_logs
    "+----------------------------------------------------------------------------------+\n"+
    "|                               Timecode Report                                    |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "#{timecode_logs}\n"
  end

  def employee_client_summary_report client_logs
    "+----------------------------------------------------------------------------------+\n"+
    "|                                Client Report                                     |\n"+
    "+----------------------------------------------------------------------------------+\n"+
    "#{client_logs}\n"
  end

end
