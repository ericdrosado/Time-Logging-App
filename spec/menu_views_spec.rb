require_relative '../lib/menu_views'

describe 'MenuViews' do

  before(:each) {@menu_views = MenuViews.new}

  logger_welcome_view = "+----------------------------------------------------------------+\n"+
                        "|                      Welcome to Time Logger                    |\n"

  logger_employee_options_view = "+----------------------------------------------------------------------------------+\n"+
                                 "|                                  Options Menu                                    |\n"+
                                 "+----------------------------------------------------------------------------------+\n"+
                                 "| Please type the number corresponding to the option you would like and press enter|\n"+
                                 "+----------------------------------------------------------------------------------+\n"+
                                 "|0. Log Out                                                                        |\n"+
                                 "|1. Enter Time                                                                     |\n"+
                                 "|2. Get Time Report                                                                |\n"+
                                 "+----------------------------------------------------------------------------------+\n"

 logger_client_view_list = " Yello\n"+
                           "+----------------------------------------------------------------------------------+\n"

 logger_timecode_report_view = "+----------------------------------------------------------------------------------+\n"+
                               "|                               Timecode Report                                    |\n"+
                               "+----------------------------------------------------------------------------------+\n"+
                               "| Below is your timecode report for the current month:                             |\n"+
                               "+----------------------------------------------------------------------------------+\n"+
                               "Total Billable Work Hours this month: 20\n"


  describe '#get_view' do

    it 'will print the welcome_view ' do
      expect(@menu_views.get_view(:welcome_view)).to eq logger_welcome_view
    end

    it 'will print the employee_options_view' do
      expect(@menu_views.get_view(:employee_options_view)).to eq logger_employee_options_view
    end

  end

  describe '#get_parameter_view' do

    it 'will print the client_list ' do
      expect(@menu_views.get_parameter_view(:client_list_view, 'Yello')).to eq logger_client_view_list
    end

    it 'will print the timecode_report_view' do
      parameter = 'Total Billable Work Hours this month: 20'

      expect(@menu_views.get_parameter_view(:timecode_report_view, parameter)).to eq logger_timecode_report_view
    end

  end

end
