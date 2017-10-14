require_relative '../lib/user_report_handler'
require 'Date'

describe 'UserReportHandler' do

  before(:each) {@user_report_handler = UserReportHandler.new}

  describe '#build_timecode_report' do

    it 'will return a timecode report for an employee' do
      expect(@user_report_handler.build_timecode_report([['10/10/2017','8','PTO']])).to eq "Total Billable Work Hours this month: 0\nTotal Non-billable Work Hours this month: 0\nTotal PTO Hours this month: 8"
    end

  end

  describe '#build_client_report' do

    it 'will return a client report for an employee' do
      expect(@user_report_handler.build_client_report(['Yello','AMA'],[['10/10/2017','8','Billable Work', 'Yello']])).to eq "For Yello employee worked 8 hours\nFor AMA employee worked 0 hours"
    end

  end

  describe '#build_detailed_report' do

    it 'will return a detailed report for an employee' do
      expect(@user_report_handler.build_detailed_report([['10/10/2017','8','PTO']])).to eq "10/10/2017,8,PTO"
    end

  end

end
