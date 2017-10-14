require_relative '../lib/csv_reader_writer'
require_relative '../lib/data_manager'
require_relative 'mocks/mock_io_handler'
require_relative '../lib/menu_views'
require_relative '../lib/report_builder'
require_relative '../lib/time_logger'
require_relative '../lib/validate_input'
require_relative '../lib/view_manager'
require_relative '../lib/view_prompts'

describe 'DataManager' do

  before(:each) do
    @csv_rw = CSVReaderWriter.new
    @validate_input = ValidateInput.new
    @data_manager = DataManager.new(@csv_rw, @validate_input)
    @mock_io_handler = MockIOHandler.new
    @menu_views = MenuViews.new
    @view_prompts = ViewPrompts.new
    @view_manager = ViewManager.new(@mock_io_handler, @menu_views, @view_prompts)
    @report_builder = ReportBuilder.new(@employees_report_handler, @user_report_handler)
    @time_logger = TimeLogger.new(@data_manager, @report_builder, @view_manager)
  end

  describe '#get_individual_user_data' do

    it 'will return :invalid if a user file does not exist' do
      expect(@data_manager.get_individual_user_data('FooBar BarFoo')).to eq :invalid
    end

    it 'will return the log of a user if the file exists' do
      expect(@data_manager.get_individual_user_data('Eric Rosado')).to include ['25/08/2017','8','PTO']
    end

  end

  describe '#get_employee_data' do

    it 'will return the log of an employee' do
      allow(@data_manager).to receive(:get_employee_names).and_return(['Eric Rosado'])

      expect(@csv_rw).to receive(:csv_reader)

      @data_manager.get_employee_data
    end

  end

  describe '#log_in' do

    it 'will return :run_logger if the permission is invalid' do
      allow(@data_manager).to receive(:call_menu_options).with(:invalid, @time_logger, @view_manager).and_return(:run_logger)

      expect(@data_manager.log_in('FooBar BarFoo', @time_logger, @view_manager)).to eq :run_logger
    end

    it 'will return :admin_options_view if the permission is admin' do
      allow(@data_manager).to receive(:call_menu_options).with('admin', @time_logger, @view_manager).and_return(:admin_options_view)

      expect(@data_manager.log_in('Eric Rosado', @time_logger, @view_manager)).to eq :admin_options_view
    end

    it 'will return :employee_options_view if the permission is employee' do
      allow(@data_manager).to receive(:call_menu_options).with('employee', @time_logger, @view_manager).and_return(:employee_options_view)

      expect(@data_manager.log_in('John Doe', @time_logger, @view_manager)).to eq :employee_options_view
    end

  end

  describe '#enter_time' do

    it 'will write an entry into an employees log if it is a valid entry' do
      allow(@csv_rw).to receive(:csv_writer).with(['25/08/2017','8','PTO'], "../../data/eric_rosado_log.csv")

      employee_log = @csv_rw.csv_reader("../../data/eric_rosado_log.csv")

      expect(employee_log).to include ['25/08/2017','8','PTO']
    end

    it 'will return :invalid with an invalid date for an entry' do
      expect(@data_manager.enter_time(['32/08/2017','8','PTO'], 'Eric Rosado', @view_manager)).to eq :invalid
    end

    it 'will return :invalid with an invalid number of hours for an entry' do
      expect(@data_manager.enter_time(['32/08/2017','25','PTO'], 'Eric Rosado', @view_manager)).to eq :invalid
    end

    it 'will return :invalid with an invalid timecode entry' do
      expect(@data_manager.enter_time(['32/08/2017','8','Timecode'], 'Eric Rosado', @view_manager)).to eq :invalid
    end

  end

  describe '#add_employee' do

    it 'will add a new employee to the system' do
      expect(@csv_rw).to receive(:csv_writer)

      @data_manager.add_employee('Foo Bar', 'employee')
    end

    it 'will return :invalid with an invalid name entry' do
      expect(@data_manager.add_employee('Eric Rosado', 'employee')).to eq :invalid
    end

    it 'will return :invalid with an invalid permission entry' do
      expect(@data_manager.add_employee('Eric Rosado', 'employ')).to eq :invalid
    end

  end

  describe '#get_user_permissions' do

    it 'will return the permission of a user' do
      expect(@data_manager.get_user_permissions('Eric Rosado')).to eq 'admin'
    end

    it 'will return :invalid if the user is not in the system' do
      expect(@data_manager.get_user_permissions('Foo Bar')).to eq :invalid
    end

  end

  describe '#add_client' do

    it 'will add a client to the system' do
      expect(@csv_rw).to receive(:csv_writer)

      @data_manager.add_client('Foo Bar')
    end

    it 'will return :invalid if the client exists in the system' do
      expect(@data_manager.add_client('Yello')).to eq :invalid
    end

  end

  describe '#get_client_list' do

    it 'will return a list of clients' do
      allow(@csv_rw).to receive(:csv_reader).and_return(['Yello'])

      expect(@data_manager.get_client_list).to eq ['Yello']
    end

  end

  describe '#get_employee_names' do

    it 'will return a list of employees' do
      allow(@csv_rw).to receive(:csv_reader).and_return([['Eric Rosado','admin'], ['John Doe','employee']])

      expect(@data_manager.get_employee_names).to eq ["Eric Rosado", "John Doe"]
    end

  end

end
