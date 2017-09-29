class Prompter

  def get_prompt prompt
    send(prompt)
  end

  private

  def request_name
    "+----------------------------------------------------------------+\n"+
    "|Please enter your full name and press enter (ex. 'John Doe'):   |\n"+
    "+----------------------------------------------------------------+\n"
  end

  def not_employee
    "+----------------------------------------------------------------+\n"+
    "|I'm sorry. This name is not in the system as an employee.       |\n"+
    "|Please make sure you spelled your name correctly using a        |\n"+
    "|capital letter for the first letter of your first and last name.|"
  end

  def request_time_entry
    "+----------------------------------------------------------------+\n"+
    "|Please enter the date, hours worked, and timecode in the correct|\n"+
    "|format as follows: day/month/year,hours worked,timecode         |\n"+
    "|ex. 23/09/2017,8,Billable Work                                  |\n"+
    "+----------------------------------------------------------------+\n"+
    "|Timecodes: Billable Work, Non-billable Work, PTO                |\n"+
    "+----------------------------------------------------------------+\n"
  end

  def invalid_entry
    "|I'm sorry, that is an invalid entry. Ensure that your entry is typed exactly as it|\n"+
    "|appears. Please choose an option from the menu and try again.                     |\n"+
    "+----------------------------------------------------------------------------------+\n"
  end

  def successful_operation
    "+----------------------------------------------------------------+\n"+
    "|The operation has been completed successfully                   |\n"+
    "+----------------------------------------------------------------+\n"
  end

end
