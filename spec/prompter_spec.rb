require_relative '../lib/prompter'

describe 'Prompter' do

  before {@prompter = Prompter.new}

  request_name_prompt = "+----------------------------------------------------------------+\n"+
                        "|Please enter your full name and press enter (ex. 'John Doe'):   |\n"+
                        "+----------------------------------------------------------------+\n"
  not_employee_prompt = "+----------------------------------------------------------------+\n"+
                        "|I'm sorry. This name is not in the system as an employee.       |\n"+
                        "|Please make sure you spelled your name correctly using a        |\n"+
                        "|capital letter for the first letter of your first and last name.|"

  describe '#get_prompt' do
    it 'will get the request_name prompt' do
      prompt = :request_name
      expect(@prompter.get_prompt(prompt)).to eq request_name_prompt
    end
    it 'will get the not_employee prompt' do
      prompt = :not_employee
      expect(@prompter.get_prompt(prompt)).to eq not_employee_prompt
    end
  end

end
