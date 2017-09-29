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
end
