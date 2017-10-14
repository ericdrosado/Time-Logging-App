require_relative '../lib/csv_reader_writer'

describe 'CSVReaderWriter' do

  before(:each) {@csv_rw = CSVReaderWriter.new}
  ENTRY = ['10/10/2017','9','Billable Work','American Medical Association']

  describe '#csv_writer' do

    it 'will write an entry to a csv file' do
      @csv_rw.csv_writer(ENTRY, '../../spec/mocks/mock_employee_log.csv')
      log = @csv_rw.csv_reader('../../spec/mocks/mock_employee_log.csv')

      expect(log).to include ENTRY
    end

    it 'will read an entry in a csv file' do
      log = @csv_rw.csv_reader('../../spec/mocks/mock_admin_log.csv')

      expect(log).to eq [ENTRY]
    end

  end

end
