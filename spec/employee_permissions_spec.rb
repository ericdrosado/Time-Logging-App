require_relative '../lib/employee_permissions'
require_relative '../lib/validator'

describe 'EmployeePermissions' do

  mock_path = File.expand_path('../../spec/mocks/mock_admin_log.csv', __FILE__)
  date = "#{Date.today.day}/#{Date.today.month}/#{Date.today.year}"
  hours = "9"
  type_of_work = "Billable Work"
  client = "American Medical Association"
  entry = [date,hours,type_of_work,client]
  CSV.open(mock_path, "wb") do |csv|
      csv << entry
  end

  timecode_report = "Total Billable Work Hours this month: 9\n"+
                     "Total Non-billable Work Hours this month: 0\n"+
                     "Total PTO Hours this month: 0"
  client_report = "For American Medical Association employee worked 9 hours\n"+
                  "For Next College Student Athlete employee worked 0 hours\n"+
                  "For Yello employee worked 0 hours"
  detailed_report = "#{Date.today.day}/#{Date.today.month}/#{Date.today.year},9,Billable Work,American Medical Association"

  before do
    @validator = Validator.new
    @employee_permissions = EmployeePermissions.new(@validator)
  end

  describe '#evaluate_permissions' do
    it 'will return employee user_type' do
      user_name = 'John Doe'
      expect(@employee_permissions.evaluate_permissions(user_name)).to eq 'employee'
    end
    it 'will return admin user_type' do
      user_name = 'Eric Rosado'
      expect(@employee_permissions.evaluate_permissions(user_name)).to eq 'admin'
    end
  end

  describe '.get_user_permissions' do
    it "will return 'employee' string given employee name" do
      name = 'John Doe'
      expect(@employee_permissions.get_user_permissions(name)).to eq 'employee'
    end
    it "will return 'admin' string given admin name" do
      name = 'Eric Rosado'
      expect(@employee_permissions.get_user_permissions(name)).to eq 'admin'
    end
  end

  describe '#enter_time' do

    client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']
    user_name = 'John Doe'

    it 'will log a valid time entry for Billable Work' do
      entry = ['23/09/2017','8','Billable Work']
      allow(@validator).to receive(:validate_time_entry).with(entry, client_list).and_return(true)
      expect(@employee_permissions).to receive(:log_time).with(entry, user_name)
      @employee_permissions.enter_time(entry, user_name, client_list)
    end
    it 'will log a valid time entry for Non-billable work' do
      entry = ['24/09/2017','8','Non-billable work']
      allow(@validator).to receive(:validate_time_entry).with(entry, nil).and_return(true)
      expect(@employee_permissions).to receive(:log_time).with(entry, user_name)
      @employee_permissions.enter_time(entry, user_name)
    end
    it 'will log a valid time entry for PTO' do
      entry = ['25/09/2017','8','PTO']
      allow(@validator).to receive(:validate_time_entry).with(entry, nil).and_return(true)
      expect(@employee_permissions).to receive(:log_time).with(entry, user_name)
      @employee_permissions.enter_time(entry, user_name)
    end
    it "will return 'invalid' given an invalid Billable Work entry" do
      entry = ['23/09/2017','8','billable Work']
      allow(@validator).to receive(:validate_time_entry).with(entry, client_list).and_return(false)
      expect(@employee_permissions.enter_time(entry, user_name, client_list)).to eq 'invalid'
    end
    it "will return 'invalid' given an invalid Non-billable work entry" do
      entry = ['24/09/2017','8','non-billable work']
      allow(@validator).to receive(:validate_time_entry).with(entry, nil).and_return(false)
      expect(@employee_permissions.enter_time(entry, user_name)).to eq 'invalid'
    end
    it "will return 'invalid' given an invalid PTO entry" do
      entry = ['25/09/2017','8','PTO']
      allow(@validator).to receive(:validate_time_entry).with(entry, nil).and_return(false)
      expect(@employee_permissions.enter_time(entry, user_name)).to eq 'invalid'
    end
  end

  describe '.create_path' do

    it 'will return a path to John Doe csv file' do
      user_name = 'John Doe'
      path = File.expand_path("../../data/john_doe_log.csv", __FILE__)
      expect(@employee_permissions.create_path(user_name)).to eq path
    end
    it 'will return a path to Eric Rosado csv file' do
      user_name = 'Eric Rosado'
      path = File.expand_path("../../data/eric_rosado_log.csv", __FILE__)
      expect(@employee_permissions.create_path(user_name)).to eq path
    end
  end

  describe '.get_client_list' do
    it 'will return client list' do
      allow(@employee_permissions).to receive(:get_client_list).and_return(['American Medical Association', 'Next College Student Athlete', 'Yello'])
      expect(@employee_permissions.get_client_list).to eq ['American Medical Association', 'Next College Student Athlete', 'Yello']
    end
  end

  describe '#get_time_report' do
    it 'will return an array with views and reports' do
      user_name = 'Spec Doe'
      path = File.expand_path("../../data/spec_doe_log.csv", __FILE__)
      allow(@employee_permissions).to receive(:create_path).with(user_name).and_return(path)
      allow(File).to receive(:file?).with(path).and_return(true)
      allow(@employee_permissions).to receive(:build_timecode_report).with(path).and_return(timecode_report)
      allow(@employee_permissions).to receive(:build_client_report).with(path).and_return(client_report)
      allow(@employee_permissions).to receive(:build_detailed_report).with(path).and_return(detailed_report)
      expect(@employee_permissions.get_time_report(user_name)).to eq [[:timecode_report_view, timecode_report],
                                                                      [:client_report_view, client_report],
                                                                      [:detailed_report_view, detailed_report]]
    end
    it "will return 'invalid' if log does not exist for user" do
      user_name = 'Spec Doe'
      path = File.expand_path("../../data/spec_doe_log.csv", __FILE__)
      allow(@employee_permissions).to receive(:create_path).with(user_name).and_return(path)
      allow(File).to receive(:file?).with(path).and_return(false)
      expect(@employee_permissions.get_time_report(user_name)).to eq 'invalid'
    end
  end

  describe '.build_timecode_report' do
    it 'will return a string with a timecode report' do
      expect(@employee_permissions.build_timecode_report(mock_path)).to eq timecode_report
    end
  end

  describe '.build_client_report' do
    it 'will return a string with a client report' do
      allow(@employee_permissions).to receive(:get_client_list).and_return(['American Medical Association','Next College Student Athlete','Yello'])
      expect(@employee_permissions.build_client_report(mock_path)).to eq client_report
    end
  end

  describe '.prepare_client_report' do
    it 'will return a string for client report given hash data' do
      client_list_hash = {Yello:8}
      expect(@employee_permissions.prepare_client_report(client_list_hash)).to eq "For Yello employee worked 8 hours"
    end
  end

  describe '.build_detailed_report' do
    it 'will return a string with a detailed report' do
      expect(@employee_permissions.build_detailed_report(mock_path)).to eq detailed_report
    end
  end

  describe '.get_month_from_data' do
    it 'will return the month from a time log' do
      time_log = ['22/08/2017','8','Billable Work','Yello']
      expect(@employee_permissions.get_month_from_data(time_log)).to eq 8
    end
  end

end
