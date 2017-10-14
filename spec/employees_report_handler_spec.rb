require_relative '../lib/employees_report_handler'
require 'Date'

describe 'EmployeesReportHandler' do

  before(:each) {@employees_report_handler = EmployeesReportHandler.new}

  describe '#build_summary_timecode_report' do

    it 'will return a timecode report for employees' do
      expect(@employees_report_handler.build_summary_timecode_report([[['10/9/2017','8','PTO']]])).to eq ["Total Billable Work Hours last month: 0\n"+
                                                                                                        "Total Non-billable Work Hours last month: 0\n"+
                                                                                                        "Total PTO Hours last month: 8"]
    end

  end

  describe '#build_summary_client_report' do

    it 'will return a client report for employees' do
      expect(@employees_report_handler.build_summary_client_report([[['10/9/2017','8','Billable Work', 'Yello']]], ['Yello','AMA'])).to eq ["For Yello employee worked 8 hours\nFor AMA employee worked 0 hours"]
    end

  end

end
