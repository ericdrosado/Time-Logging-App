require_relative './mocks/mock_io_handler'
require_relative '../lib/logger_view'
require_relative '../lib/prompter'

describe 'LoggerView' do

  before do
    @mock_io_handler = MockIOHandler.new
    prompter = Prompter.new
    @logger_view = LoggerView.new(@mock_io_handler, prompter)
  end

  request_name_prompt = "+----------------------------------------------------------------+\n"+
                        "|Please enter your full name and press enter (ex. 'John Doe'):   |\n"+
                        "+----------------------------------------------------------------+\n"
  not_employee_prompt = "+----------------------------------------------------------------+\n"+
                        "|I'm sorry. This name is not in the system as an employee.       |\n"+
                        "|Please make sure you spelled your name correctly using a        |\n"+
                        "|capital letter for the first letter of your first and last name.|"

  logger_welcome_view = "+----------------------------------------------------------------+\n"+
                        "|                      Welcome to Time Logger                    |\n"

  logger_employee_options_view = "+----------------------------------------------------------------------------------+\n"+
                                 "|                                  Options Menu                                    |\n"+
                                 "+----------------------------------------------------------------------------------+\n"+
                                 "| Please type the number corresponding to the option you would like and press enter|\n"+
                                 "+----------------------------------------------------------------------------------+\n"+
                                 "|0. Log Out                                                                        |\n"+
                                 "|1. Enter Time                                                                     |\n"+
                                 "|2. Get Time Report                                                                |\n"+
                                 "+----------------------------------------------------------------------------------+\n"

  logger_client_view_list = " Yello\n"+
                            "+----------------------------------------------------------------------------------+\n"

  describe 'get_prompt' do
    it 'will return request_name prompt from prompter class' do
      prompt = :request_name
      expect(@logger_view.get_prompt(prompt)).to eq request_name_prompt
    end
    it 'will return not_employee prompt from prompter class' do
      prompt = :not_employee
      expect(@logger_view.get_prompt(prompt)).to eq not_employee_prompt
    end
  end

  describe 'print_view' do
    it 'will print the welcome_view ' do
      view = :welcome_view
      expect(@logger_view.print_view(view)).to eq logger_welcome_view
    end
    it 'will print the employee_options_view' do
      view = :employee_options_view
      expect(@logger_view.print_view(view)).to eq logger_employee_options_view
    end
  end

  describe 'print_parameter_view' do
    it 'will print the client_list ' do
      view = :client_list_view
      parameter = "Yello"
      expect(@logger_view.print_parameter_view(view, parameter )).to eq logger_client_view_list
    end
  end

  describe 'get_input' do
    it "will receive the input 'foo' " do
      expect(@mock_io_handler).to receive(:get_input).and_return('foo')
      expect(@logger_view.get_input).to eq 'foo'
    end
    it "will receive the input 'bar' " do
      expect(@mock_io_handler).to receive(:get_input).and_return('bar')
      expect(@logger_view.get_input).to eq 'bar'
    end
  end

end
