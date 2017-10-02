require_relative '../lib/admin_permissions'
require_relative '../lib/validator'

describe 'AdminPermissions' do

  EMPLOYEE_PERMISSIONS_FILE = File.expand_path('../../data/employee_permissions.csv', __FILE__)
  CLIENT_LIST_FILE = File.expand_path('../../data/client_list.csv', __FILE__)

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

end
