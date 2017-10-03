require_relative '../lib/admin_permissions'
require_relative '../lib/validator'

describe 'AdminPermissions' do

  EMPLOYEE_PERMISSIONS_FILE = File.expand_path('../../data/employee_permissions.csv', __FILE__)
  CLIENT_LIST_FILE = File.expand_path('../../data/client_list.csv', __FILE__)

  mock_path = File.expand_path('../../spec/mocks/mock_employee_log.csv', __FILE__)
  date = "#{Date.today.day}/#{Date.today.month - 1}/#{Date.today.year}"
  hours = "9"
  type_of_work = "Billable Work"
  client = "American Medical Association"
  entry = [date,hours,type_of_work,client]
  CSV.open(mock_path, "wb") do |csv|
      csv << entry
  end

  summary_timecode_report = ["Total Billable Work Hours last month: 9\n"+
                     "Total Non-billable Work Hours last month: 0\n"+
                     "Total PTO Hours last month: 0"]
  summary_client_report = ["For American Medical Association employee worked 9 hours\n"+
                  "For Next College Student Athlete employee worked 0 hours\n"+
                  "For Yello employee worked 0 hours"]

  before do
    @validator = Validator.new
    @admin_permissions = AdminPermissions.new(@validator)
  end

  describe '#add_employee' do
    it 'will add employee to employee_permissions.csv with valid name and permission' do
      name = 'Spec Doe'
      permission = 'employee'
      allow(@admin_permissions).to receive(:split).with(:name)
      allow(@admin_permissions).to receive(:map).with(:capitalize)
      allow(@admin_permissions).to receive(:join).with(' ').and_return('Spec Doe')
      allow(@admin_permissions).to receive(:get_employee_names).and_return(['John Spec'])
      allow(@validator).to receive(:valid_new_employee_entry?).with(name, permission, ['John Spec']).and_return(true)
      expect(CSV).to receive(:open).with(EMPLOYEE_PERMISSIONS_FILE, 'a+')
      @admin_permissions.add_employee(name, permission)
    end
    it "will return 'invalid' with an invalid name" do
      name = '!Spec Doe'
      permission = 'employee'
      allow(@admin_permissions).to receive(:split).with(:name)
      allow(@admin_permissions).to receive(:map).with(:capitalize)
      allow(@admin_permissions).to receive(:join).with(' ').and_return('!Spec Doe')
      allow(@admin_permissions).to receive(:get_employee_names).and_return(['Spec Doe'])
      allow(@validator).to receive(:valid_new_employee_entry?).with(name, permission, ['Spec Doe']).and_return(false)
      expect(@admin_permissions.add_employee(name, permission)).to eq 'invalid'
    end
    it "will return 'invalid' with an invalid permission" do
      name = 'Spec Doe'
      permission = 'administrator'
      allow(@admin_permissions).to receive(:split).with(:name)
      allow(@admin_permissions).to receive(:map).with(:capitalize)
      allow(@admin_permissions).to receive(:join).with(' ').and_return('Spec Doe')
      allow(@admin_permissions).to receive(:get_employee_names).and_return(['Spec Doe'])
      allow(@validator).to receive(:valid_new_employee_entry?).with(name, permission, ['Spec Doe']).and_return(false)
      expect(@admin_permissions.add_employee(name, permission)).to eq 'invalid'
    end
  end

  describe '.get_employee_names' do
    it 'will return an array of employee names from employee_permissions.csv' do
      employee_names = []
      CSV.foreach(EMPLOYEE_PERMISSIONS_FILE) do |row|
        employee_names << row[0]
      end
      expect(@admin_permissions.get_employee_names).to eq employee_names
    end
  end

  describe '#add_client' do
    it 'will add a new client to client_list.csv with valid client name' do
      client_name = 'Enova'
      client_list = ['American Medical Association', 'Yello']
      allow(@admin_permissions).to receive(:get_client_names).and_return(client_list)
      allow(@validator).to receive(:valid_new_client_entry?).with(client_name, client_list).and_return(true)
      expect(CSV).to receive(:open).with(CLIENT_LIST_FILE, 'a+')
      @admin_permissions.add_client(client_name)
    end
    it "will return 'invalid' given an invalid client_name" do
      client_name = 'Enova'
      client_list = ['American Medical Association', 'Yello']
      allow(@admin_permissions).to receive(:get_client_names).and_return(client_list)
      allow(@validator).to receive(:valid_new_client_entry?).with(client_name, client_list).and_return(false)
      expect(@admin_permissions.add_client(client_name)).to eq 'invalid'
    end
  end

  describe '.get_client_names' do
    it 'will return an array of client names from client_list.csv' do
      client_names = []
      CSV.foreach(CLIENT_LIST_FILE) do |row|
        client_names << row[0]
      end
      expect(@admin_permissions.get_client_names).to eq client_names
    end
  end

  describe '#get_employee_time_report' do
    it 'will return an array with views and reports' do
      path = File.expand_path('../../spec/mocks/mock_employee_log.csv', __FILE__)
      employee_names = ['Employee', 'Mock Employee']
      allow(@admin_permissions).to receive(:get_employee_names).and_return(employee_names)
      allow(@admin_permissions).to receive(:create_path).with('Mock Employee').and_return(path)
      allow(@admin_permissions).to receive(:build_summary_timecode_report).with([path]).and_return(summary_timecode_report)
      allow(@admin_permissions).to receive(:build_summary_client_report).with([path]).and_return(summary_client_report)
      expect(@admin_permissions.get_employee_time_report).to eq [[:employee_name_view, ['Mock Employee']],
                                                                [:employee_timecode_summary_report, summary_timecode_report],
                                                                [:employee_client_summary_report, summary_client_report]]
    end
  end

  describe '.build_summary_timecode_report' do
    it 'will return an array of timecode summary reports for employees' do
      expect(@admin_permissions.build_summary_timecode_report([mock_path])).to eq summary_timecode_report
    end
  end

  describe '.build_summary_client_report' do
    it 'will return an array of client summary reports for employees' do
      allow(@admin_permissions).to receive(:get_client_list).and_return(['American Medical Association','Next College Student Athlete','Yello'])
      expect(@admin_permissions.build_summary_client_report([mock_path])).to eq summary_client_report
    end
  end

end
