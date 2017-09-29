require_relative '../lib/employee_permissions'
require_relative '../lib/validator'

describe 'EmployeePermissions' do

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
      entry = ['25/09/2017','8','pTO']
      allow(@validator).to receive(:validate_time_entry).with(entry, nil).and_return(false)
      expect(@employee_permissions.enter_time(entry, user_name)).to eq 'invalid'
    end
  end

  describe '.create_path' do
    it 'will return a path to John Doe csv file' do
      user_name = 'John Doe'
      expect(@employee_permissions.create_path(user_name)).to eq '../../data/john_doe_log.csv'
    end
    it 'will return a path to Eric Rosado csv file' do
      user_name = 'Eric Rosado'
      expect(@employee_permissions.create_path(user_name)).to eq '../../data/eric_rosado_log.csv'
    end
  end

  describe '.get_client_list' do
    it 'will return client list' do
      expect(@employee_permissions.get_client_list).to eq ['American Medical Association', 'Next College Student Athlete', 'Yello']
    end
  end
end
