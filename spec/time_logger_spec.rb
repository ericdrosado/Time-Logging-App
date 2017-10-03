require_relative '../lib/admin_permissions'
require_relative '../lib/employee_permissions'
require_relative './mocks/mock_io_handler'
require_relative '../lib/logger_view'
require_relative '../lib/prompter'
require_relative '../lib/time_logger'
require_relative '../lib/validator'

describe 'TimeLogger' do

  before do
    @mock_io_handler = MockIOHandler.new
    @prompter = Prompter.new
    @logger_view = LoggerView.new(@mock_io_handler, @prompter)
    @validator = Validator.new
    @admin_permissions = AdminPermissions.new(@validator)
    @employee_permissions = EmployeePermissions.new(@validator)
    @time_logger = TimeLogger.new(@admin_permissions, @employee_permissions, @logger_view)
  end

  describe '#start_logger' do
    it 'will display a welcome and receive call_options_view' do
      allow(@logger_view).to receive(:clear_view)
      allow(@logger_view).to receive(:print_view).with(:welcome_view)
      expect(@time_logger).to receive(:call_options_view)
      @time_logger.start_logger
    end
  end

  describe '.call_options_view' do
    it 'will call employee_options_view menu based on login permissions' do
      allow(@time_logger).to receive(:get_permission_level).and_return("employee")
      allow(@logger_view).to receive(:print_view).with("employee_options_view")
      allow(@time_logger).to receive(:send).and_return(:employee_options_view)
      expect(@time_logger.call_options_view).to eq(:employee_options_view)
    end
    it 'will call the admin_options_view menu based on login permissions' do
      allow(@time_logger).to receive(:get_permission_level).and_return("admin")
      allow(@logger_view).to receive(:print_view).with("admin_options_view")
      allow(@time_logger).to receive(:send).and_return(:admin_options_view)
      expect(@time_logger.call_options_view).to eq(:admin_options_view)
    end
  end

  describe '.get_permission_level' do
    it "will return the string 'employee' for user permissions" do
      allow(@time_logger).to receive(:get_user_name).and_return("John Doe")
      allow(@employee_permissions).to receive(:evaluate_permissions).and_return("employee")
      expect(@time_logger.get_permission_level).to eq("employee")
    end
    it "will return the string 'admin' for user permissions" do
      allow(@time_logger).to receive(:get_user_name).and_return("Eric Rosado")
      allow(@employee_permissions).to receive(:evaluate_permissions).and_return("admin")
      expect(@time_logger.get_permission_level).to eq("admin")
    end
    it 'will prompt if a user name is invalid, until the name is valid' do
      allow(@time_logger).to receive(:get_user_name).and_return("John Foo")
      allow(@employee_permissions).to receive(:evaluate_permissions).and_return(nil)
      allow(@logger_view).to receive(:get_prompt).with(:request_name)
      allow(@time_logger).to receive(:get_user_name).and_return("John Doe")
      allow(@employee_permissions).to receive(:evaluate_permissions).and_return("employee")
      expect(@time_logger.get_permission_level).to eq("employee")
    end
  end

  describe '.get_user_name' do
    it 'will return the user name' do
      allow(@logger_view).to receive(:get_prompt).with(:request_name)
      allow(@logger_view).to receive(:get_input).and_return("John Doe")
      expect(@time_logger.get_user_name).to eq("John Doe")
    end
  end

  describe '.enter_time' do

    let(:permissions) {:permissions}
    let(:options_view) {:options_view}
    let(:options) {:options}

    it 'will manage the operations required to log a time entry' do
      allow(@time_logger).to receive(:get_log_entry).and_return(:entry)
      allow(@time_logger).to receive(:log_entry).with(:entry, :permissions).and_return(:entry_status)
      allow(@time_logger).to receive(:evaluate_entry_status).with(:entry_status, :options_view, :options)
      expect(@time_logger).to receive(:evaluate_entry_status)
      @time_logger.enter_time(permissions, options_view, options)
    end
  end

  describe '.get_log_entry' do
    it 'will return a user entry' do
      allow(@logger_view).to receive(:clear_view)
      allow(@logger_view).to receive(:time_entry_view)
      allow(@logger_view).to receive(:request_time_entry)
      allow(@logger_view).to receive(:get_input).and_return('23/09/2017,8,Billable Work')
      allow(@time_logger).to receive(:split).and_return(['23/09/2017', '8', 'Billable Work'])
      expect(@time_logger.get_log_entry).to eq ['23/09/2017', '8', 'Billable Work']
    end
  end

  describe '.log_entry' do
    it 'will log a time entry into a csv file for Billable Work' do
      entry = ['23/09/2017', '8', 'Billable Work']
      client_list = ["American Medical Association", "Next College Student Athlete", "Yello"]
      entry_with_client = ['23/09/2017', '8', 'Billable Work', 'Yello']
      @time_logger.instance_variable_set(:@user_name, 'John Doe')
      allow(@time_logger).to receive(:choose_client).with(entry, client_list).and_return(['23/09/2017', '8', 'Billable Work', 'Yello'])
      allow(@employee_permissions).to receive(:enter_time).with(entry_with_client, 'John Doe', client_list).and_return('valid')
      expect(@time_logger.log_entry(entry, @employee_permissions)).to eq 'valid'
    end
    it 'will log a time entry into a csv file for Non-billable work' do
      entry = ['24/09/2017', '8', 'Non-billable work']
      @time_logger.instance_variable_set(:@user_name, 'John Doe')
      allow(@employee_permissions).to receive(:enter_time).with(entry, 'John Doe').and_return('valid')
      expect(@time_logger.log_entry(entry, @employee_permissions)).to eq 'valid'
    end
    it 'will log a time entry into a csv file for PTO' do
      entry = ['25/09/2017', '8', 'PTO']
      @time_logger.instance_variable_set(:@user_name, 'John Doe')
      allow(@employee_permissions).to receive(:enter_time).with(entry, 'John Doe').and_return('valid')
      expect(@time_logger.log_entry(entry, @employee_permissions)).to eq 'valid'
    end
    it 'will not log an incorrect date entry' do
      entry = ['29/02/2017', '8', 'PTO']
      @time_logger.instance_variable_set(:@user_name, 'John Doe')
      allow(@employee_permissions).to receive(:enter_time).with(entry, 'John Doe').and_return('invalid')
      expect(@time_logger.log_entry(entry, @employee_permissions)).to eq 'invalid'
    end
    it 'will not log an incorrect hour entry' do
      entry = ['29/02/2017', 'H', 'PTO']
      @time_logger.instance_variable_set(:@user_name, 'John Doe')
      allow(@employee_permissions).to receive(:enter_time).with(entry, 'John Doe').and_return('invalid')
      expect(@time_logger.log_entry(entry, @employee_permissions)).to eq 'invalid'
    end
    it 'will not log an incorrect timecode entry' do
      entry = ['29/02/2017', '8', 'timecode']
      @time_logger.instance_variable_set(:@user_name, 'John Doe')
      allow(@employee_permissions).to receive(:enter_time).with(entry, 'John Doe').and_return('invalid')
      expect(@time_logger.log_entry(entry, @employee_permissions)).to eq 'invalid'
    end
  end

  describe '.choose_client' do
    it 'will let the user choose a client' do
      entry = ['23/09/2017', '8', 'Billable Work']
      client_list = ["American Medical Association", "Next College Student Athlete", "Yello"]
      allow(@logger_view).to receive(:get_input).and_return("Yello")
      expect(@time_logger.choose_client(entry, client_list)).to eq ['23/09/2017', '8', 'Billable Work', 'Yello']
    end
  end

  describe '.invalid_entry' do
    it 'will receive evaluate_entry_status from time_logger ' do
      entry_status = 'invalid'
      options_view = double()
      options = 'employee_options'
      expect(@time_logger).to receive(:evaluate_entry_status).with(entry_status, options_view, options)
      @time_logger.invalid_entry(options_view, options)
    end
  end

  describe '.evaluate_entry_status' do

    options_view = :options_view
    options = "employee_options"

    it 'will prompt invalid_entry and return employee_options view when entry_status is invalid' do
      entry_status = "invalid"
      prompt = :invalid_entry
      expect(@time_logger).to receive(:get_view_for_invalid_entry).with(prompt, options_view, options)
      @time_logger.evaluate_entry_status(entry_status, options_view, options)
    end
    it 'will prompt successful_operation and return employee_options view when entry_status is valid' do
      entry_status = "valid"
      allow(@logger_view).to receive(:clear_view)
      allow(@logger_view).to receive(:print_view).with(:options_view)
      expect(@logger_view).to receive(:get_prompt).with(:successful_operation)
      expect(@time_logger).to receive(:send).and_return(:options_view)
      @time_logger.evaluate_entry_status(entry_status, options_view, options)
    end
  end

  describe '.get_log_report' do

    options_view = :options_view
    options = "employee_options"

    it 'will prompt invalid_entry and return employee_options view when report is invalid' do
      prompt = :no_log
      @time_logger.instance_variable_set(:@user_name, 'John Doe')
      allow(@employee_permissions).to receive(:get_time_report).with("John Doe").and_return('invalid')
      expect(@time_logger).to receive(:get_view_for_invalid_entry).with(prompt, options_view, options)
      @time_logger.get_log_report(@employee_permissions, options_view, options)
    end
    it 'will obtain log report data for LoggerView to display' do
      @time_logger.instance_variable_set(:@user_name, 'Mock Employee')
      allow(@employee_permissions).to receive(:get_time_report).with("Mock Employee").and_return('invalid')
      allow(@logger_view).to receive(:clear_view)
      allow(@logger_view).to receive(:print_view).with(:options_view)
      allow(@logger_view).to receive(:print_parameter_view).with(:timecode_report_view, :timecode_report)
      allow(@logger_view).to receive(:print_parameter_view).with(:client_report_view, :client_report)
      allow(@logger_view).to receive(:print_parameter_view).with(:detailed_report_view, :detailed_report)
      expect(@time_logger).to receive(:send).with(options, options_view)
      @time_logger.get_log_report(@employee_permissions, options_view, options)
    end
  end

  describe '.get_view_for_invalid_entry' do
    it 'will receive the corresponding UI for an invalid entry' do
      entry_status = "invalid"
      options_view = :options_view
      options = "employee_options"
      allow(@logger_view).to receive(:clear_view)
      expect(@logger_view).to receive(:get_prompt).with(:invalid_entry)
      allow(@logger_view).to receive(:print_view).with(:options_view)
      expect(@time_logger).to receive(:send).and_return(:options_view)
      @time_logger.evaluate_entry_status(entry_status, options_view, options)
    end
  end

  describe '.add_new_employee' do
    it 'will add an employee to employee_permissions.csv' do
      options_view = 'admin_options_view'
      new_employee = 'Spec Doe'
      allow(@logger_view).to receive(:clear_view)
      expect(@logger_view).to receive(:print_view).with(:add_employee_view)
      allow(@logger_view).to receive(:get_input).and_return(new_employee)
      expect(@logger_view).to receive(:get_prompt).with(:request_permission_type)
      allow(@logger_view).to receive(:get_input).and_return('employee')
      allow(@admin_permissions).to receive(:add_employee).and_return(nil)
      expect(@time_logger).to receive(:evaluate_entry_status).with(nil, options_view,'admin_options')
      @time_logger.add_new_employee(options_view)
    end
  end

  describe '.add_client' do
    it 'will add a new client to client_list.csv' do
      options_view = 'admin_options_view'
      new_client = 'Foo'
      allow(@logger_view).to receive(:clear_view)
      expect(@logger_view).to receive(:print_view).with(:add_client_view)
      allow(@logger_view).to receive(:get_input).and_return(new_client)
      allow(@admin_permissions).to receive(:add_client).and_return('valid')
      expect(@time_logger).to receive(:evaluate_entry_status).with('valid', options_view,'admin_options')
      @time_logger.add_client(options_view)
    end
    it 'will not add a new client since client name already exists' do
      options_view = 'admin_options_view'
      new_client = 'Yello'
      allow(@logger_view).to receive(:clear_view)
      expect(@logger_view).to receive(:print_view).with(:add_client_view)
      allow(@logger_view).to receive(:get_input).and_return(new_client)
      allow(@admin_permissions).to receive(:add_client).and_return('invalid')
      expect(@time_logger).to receive(:get_view_for_invalid_entry).with(:client_exists, options_view,'admin_options')
      @time_logger.add_client(options_view)
    end
    it 'will not add a new client since client name is blank' do
      options_view = 'admin_options_view'
      new_client = ''
      allow(@logger_view).to receive(:clear_view)
      expect(@logger_view).to receive(:print_view).with(:add_client_view)
      allow(@logger_view).to receive(:get_input).and_return(new_client)
      allow(@admin_permissions).to receive(:add_client).and_return('invalid')
      expect(@time_logger).to receive(:get_view_for_invalid_entry).with(:client_exists, options_view,'admin_options')
      @time_logger.add_client(options_view)
    end
  end

  describe '.get_employee_time_report' do
    it 'will obtain all employee time reports' do
      report = [[:employee_name_view, ['John Doe']],
                [:employee_timecode_summary_report,["Total Billable Work Hours this month: 9\n"+"Total Non-billable Work Hours this month: 0\n"+"Total PTO Hours this month: 0"]],
                [:employee_client_summary_report,["For American Medical Association you've worked 9 hours this month\n"+"For Next College Student Athlete you've worked 0 hours this month\n"+"For Yello you've worked 0 hours this month"]]]
      options_view = 'admin_options_view'
      employee_names = report[0]
      timecode_reports = report[1]
      client_reports = report[2]
      allow(@admin_permissions).to receive(:get_employee_time_report).and_return(report)
      allow(@logger_view).to receive(:clear_view)
      expect(@logger_view).to receive(:print_view).with(options_view)
      allow(@logger_view).to receive(:print_parameter_view)
      expect(@time_logger).to receive(:admin_options).with(options_view)
      @time_logger.get_employee_time_report(options_view)
    end
  end

end
