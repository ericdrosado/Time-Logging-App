describe 'Validator' do

  before { @validator = Validator.new }

  describe '#validate_time_entry' do
    it 'will return true if each entry is valid while client_list is nil' do
      entry = '23/09/2017','8','Billable Work'
      client_list = nil
      expect(@validator.validate_time_entry(entry, client_list)).to eq true
    end
    it 'will return false if date entry is invalid while client_list is nil' do
      entry = '32/09/2017','8','Billable Work','Yello'
      client_list = nil
      expect(@validator.validate_time_entry(entry, client_list)).to eq false
    end
    it 'will return false if hours entry is invalid while client_list is nil' do
      entry = '23/09/2017','w','Billable Work','Yello'
      client_list = nil
      expect(@validator.validate_time_entry(entry, client_list)).to eq false
    end
    it 'will return false if timecode entry is invalid while client_list is nil' do
      entry = '23/09/2017','8','billable Work','Yello'
      client_list = nil
      expect(@validator.validate_time_entry(entry, client_list)).to eq false
    end
    it 'will return true if each entry is valid while client_list is not nil' do
      entry = '23/09/2017','8','Billable Work','Yello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']
      expect(@validator.validate_time_entry(entry, client_list)).to eq true
    end
    it 'will return false if date entry is invalid while client_list is not nil' do
      entry = '32/09/2017','8','Billable Work','Yello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']
      expect(@validator.validate_time_entry(entry, client_list)).to eq false
    end
    it 'will return false if hours entry is invalid while client_list is not nil' do
      entry = '23/09/2017','w','Billable Work','Yello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']
      expect(@validator.validate_time_entry(entry, client_list)).to eq false
    end
    it 'will return false if timecode entry is invalid while client_list is not nil' do
      entry = '23/09/2017','8','billable Work','Yello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']
      expect(@validator.validate_time_entry(entry, client_list)).to eq false
    end
    it 'will return false if client entry is invalid while client_list is not nil' do
      entry = '23/09/2017','8','Billable Work','Bello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']
      expect(@validator.validate_time_entry(entry, client_list)).to eq false
    end
  end

  describe '.is_valid_date?' do
    it 'will return true for a valid date' do
      entry = '28/9/2017'
      expect(@validator.is_valid_date?(entry)).to eq true
    end
    it 'will return false for an invalid date' do
      entry = '32/9/2017'
      expect(@validator.is_valid_date?(entry)).to eq false
    end
  end

  describe '.is_not_future_date?' do
    it 'will return true for a non future date' do
      entry = '23/9/2017'
      expect(@validator.is_not_future_date?(entry)).to eq true
    end
    it 'will return false for a future date' do
      entry = '23/9/5000'
      expect(@validator.is_not_future_date?(entry)).to eq false
    end
  end

  describe '.is_a_number_other_than_0?' do
    it 'will return true for a non 0 number' do
      entry = '2'
      expect(@validator.is_a_number_other_than_0?(entry)).to eq true
    end
    it 'will return false for a 0' do
      entry = '0'
      expect(@validator.is_a_number_other_than_0?(entry)).to eq false
    end
  end

  describe '.is_a_valid_timecode?' do
    it 'will return true for a valid timecode' do
      entry = 'Billable Work'
      expect(@validator.is_a_valid_timecode?(entry)).to eq true
    end
    it 'will return false for an invalid timecode' do
      entry = 'non-billable work'
      expect(@validator.is_a_valid_timecode?(entry)).to eq false
    end
  end

  describe '.is_a_client?' do

    client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']

    it 'will return true for a client' do
      entry = 'Yello'
      expect(@validator.is_a_client?(entry, client_list)).to eq true
    end
    it 'will return false for a non client' do
      entry = 'Bing Bong'
      expect(@validator.is_a_client?(entry, client_list)).to eq false
    end
  end

  describe '#valid_new_employee_entry?' do
    it 'will return true if it is a valid new employee entry' do
      name = 'John Spec'
      permission = 'employee'
      employee_names = ['Eric Rosado', 'John Doe']
      expect(@validator.valid_new_employee_entry?(name, permission, employee_names)).to eq true
    end
    it 'will return false if the name is the same name of another employee' do
      name = 'John Doe'
      permission = 'employee'
      employee_names = ['Eric Rosado', 'John Doe']
      expect(@validator.valid_new_employee_entry?(name, permission, employee_names)).to eq false
    end
    it 'will return false if the permission is not a permission choice' do
      name = 'John Spec'
      permission = 'administrator'
      employee_names = ['Eric Rosado', 'John Doe']
      expect(@validator.valid_new_employee_entry?(name, permission, employee_names)).to eq false
    end
    it 'will return false if the name has characters other than letters' do
      name = 'John$ Spec'
      permission = 'administrator'
      employee_names = ['Eric Rosado', 'John Doe']
      expect(@validator.valid_new_employee_entry?(name, permission, employee_names)).to eq false
    end
  end

  describe '.is_a_valid_name?' do
    it 'will return true if the name does not have non letter characters in the name' do
      name = 'John Spec'
      expect(@validator.is_a_valid_name?(name)).to eq true
    end
    it 'will return false if the name has non letter characters in the name' do
      name = 'J0hn Spec'
      expect(@validator.is_a_valid_name?(name)).to eq false
    end
    it 'will return false if there is no space between the first and last name' do
      name = 'JohnSpec'
      expect(@validator.is_a_valid_name?(name)).to eq false
    end
  end

  describe '.is_a_valid_permission?' do
    it 'will return true if the permission is a permission choice' do
      permission = 'admin'
      expect(@validator.is_a_valid_permission?(permission)).to eq true
    end
    it 'will return false if the permission is not a permission choice' do
      permission = 'employed'
      expect(@validator.is_a_valid_permission?(permission)).to eq false
    end
  end

  describe '.not_a_used_name?' do
    it 'will return true if the new employee name is not a name already in use' do
      name = 'John Rosado'
      employee_names = ['Eric Rosado', 'John Doe']
      expect(@validator.not_a_used_name?(name, employee_names)).to eq true
    end
    it 'will return false if the new employee name is a name already in use' do
      name = 'Eric Rosado'
      employee_names = ['Eric Rosado', 'John Doe']
      expect(@validator.not_a_used_name?(name, employee_names)).to eq false
    end
  end

  describe '.valid_new_client_entry?' do
    it 'will return true if the new client name is not a name already in use' do
      client = 'Enova'
      client_names = ['American Medical Association', 'Yello']
      expect(@validator.valid_new_client_entry?(client, client_names)).to eq true
    end
    it 'will return false if the new client name is a name already in use' do
      client = 'Yello'
      client_names = ['American Medical Association', 'Yello']
      expect(@validator.valid_new_client_entry?(client, client_names)).to eq false
    end
  end

end
