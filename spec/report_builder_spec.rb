require_relative '../lib/employees_report_handler'
require_relative '../lib/report_builder'
require_relative '../lib/user_report_handler'
require 'Date'

describe 'ReportBuilder' do

  before(:each) do
    @employees_report_handler = EmployeesReportHandler.new
    @user_report_handler = UserReportHandler.new
    @report_builder = ReportBuilder.new(@employees_report_handler, @user_report_handler)
  end

  describe '#build_user_report' do

    it 'will build a log report for an employee' do
      client_list = ['Yello', 'AMA']
      log_data = [['10/10/2017','8','PTO',]]
      user_name = 'Eric Rosado'

      expect(@report_builder.build_user_report(client_list, log_data, user_name)).to eq [[:timecode_report_view,"Total Billable Work Hours this month: 0\nTotal Non-billable Work Hours this month: 0\nTotal PTO Hours this month: 8"],
                                                                                  [:client_report_view,"For Yello employee worked 0 hours\nFor AMA employee worked 0 hours"],
                                                                                  [:detailed_report_view, "10/10/2017,8,PTO"]]
    end

    it 'will return :invalid if there is no log_data for the employee' do
      client_list = ['Yello', 'AMA']
      log_data = :invalid
      user_name = 'Eric Rosado'

      expect(@report_builder.build_user_report(client_list, log_data, user_name)).to eq :invalid
    end

  end

  describe '#build_employee_time_report' do

    it 'will build a summary log report for all employees' do
      client_list = ['Yello', 'AMA']
      log_data = [['10/10/2017','8','PTO',]]
      employee_names = ['Eric Rosado','John Doe']

      expect(@report_builder.build_user_report(client_list, log_data, employee_names)).to eq [[:timecode_report_view, "Total Billable Work Hours this month: 0\nTotal Non-billable Work Hours this month: 0\nTotal PTO Hours this month: 8"],
                                                                                            [:client_report_view, "For Yello employee worked 0 hours\nFor AMA employee worked 0 hours"],
                                                                                            [:detailed_report_view, "10/10/2017,8,PTO"]]
    end

  end

end
