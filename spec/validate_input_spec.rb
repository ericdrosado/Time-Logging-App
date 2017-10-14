require_relative '../lib/validate_input'
require 'Date'

describe 'ValidateInput' do

  before { @validate_input = ValidateInput.new }

  describe '#validate_time_entry' do

    it 'will return false if date entry is invalid while client_list is nil' do
      entry = '32/09/2017','8','Billable Work','Yello'
      client_list = nil

      expect(@validate_input.validate_time_entry(entry, client_list)).to eq false
    end

    it 'will return false if hours entry is invalid while client_list is nil' do
      entry = '23/09/2017','w','Billable Work','Yello'
      client_list = nil

      expect(@validate_input.validate_time_entry(entry, client_list)).to eq false
    end

    it 'will return false if timecode entry is invalid while client_list is nil' do
      entry = '23/09/2017','8','billable Work','Yello'
      client_list = nil

      expect(@validate_input.validate_time_entry(entry, client_list)).to eq false
    end

    it 'will return true if each entry is valid while client_list is not nil' do
      entry = '23/09/2017','8','Billable Work','Yello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']

      expect(@validate_input.validate_time_entry(entry, client_list)).to eq true
    end

    it 'will return false if date entry is invalid while client_list is not nil' do
      entry = '32/09/2017','8','Billable Work','Yello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']

      expect(@validate_input.validate_time_entry(entry, client_list)).to eq false
    end

    it 'will return false if hours entry is invalid while client_list is not nil' do
      entry = '23/09/2017','w','Billable Work','Yello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']

      expect(@validate_input.validate_time_entry(entry, client_list)).to eq false
    end

    it 'will return false if timecode entry is invalid while client_list is not nil' do
      entry = '23/09/2017','8','billable Work','Yello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']

      expect(@validate_input.validate_time_entry(entry, client_list)).to eq false
    end

    it 'will return false if client entry is invalid while client_list is not nil' do
      entry = '23/09/2017','8','Billable Work','Bello'
      client_list = ['American Medical Association', 'Next College Student Athlete', 'Yello']

      expect(@validate_input.validate_time_entry(entry, client_list)).to eq false
    end

  end

  describe '#valid_new_employee_entry?' do

    it 'will return true if it is a valid new employee entry' do
      name = 'John Spec'
      permission = 'employee'
      employee_names = ['Eric Rosado', 'John Doe']

      expect(@validate_input.valid_new_employee_entry?(name, permission, employee_names)).to eq true
    end

    it 'will return false if the name is the same name of another employee' do
      name = 'John Doe'
      permission = 'employee'
      employee_names = ['Eric Rosado', 'John Doe']

      expect(@validate_input.valid_new_employee_entry?(name, permission, employee_names)).to eq false
    end

    it 'will return false if the permission is not a permission choice' do
      name = 'John Spec'
      permission = 'administrator'
      employee_names = ['Eric Rosado', 'John Doe']

      expect(@validate_input.valid_new_employee_entry?(name, permission, employee_names)).to eq false
    end

    it 'will return false if the name has characters other than letters' do
      name = 'John$ Spec'
      permission = 'administrator'
      employee_names = ['Eric Rosado', 'John Doe']

      expect(@validate_input.valid_new_employee_entry?(name, permission, employee_names)).to eq false
    end

  end

  describe '#valid_new_client_entry?' do

    it 'will return true if the new client name is not a name already in use' do
      client = 'Enova'
      client_names = ['American Medical Association', 'Yello']

      expect(@validate_input.valid_new_client_entry?(client, client_names)).to eq true
    end

    it 'will return false if the new client name is a name already in use' do
      client = 'Yello'
      client_names = ['American Medical Association', 'Yello']

      expect(@validate_input.valid_new_client_entry?(client, client_names)).to eq false
    end

    it 'will return false if the new client name is blank' do
      client = ''
      client_names = ['American Medical Association', 'Yello']

      expect(@validate_input.valid_new_client_entry?(client, client_names)).to eq false
    end

  end

end
