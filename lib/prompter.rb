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

end
