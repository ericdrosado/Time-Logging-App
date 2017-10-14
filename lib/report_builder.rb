class ReportBuilder

  def initialize employees_report_handler, user_report_handler
    @employees_report_handler = employees_report_handler
    @user_report_handler = user_report_handler
  end

  def build_user_report client_list, log_data, user_name
    if log_data != :invalid
      timecode_report = @user_report_handler.build_timecode_report(log_data)
      client_report = @user_report_handler.build_client_report(client_list, log_data)
      detailed_report = @user_report_handler.build_detailed_report(log_data)
      [[:timecode_report_view, timecode_report],
        [:client_report_view, client_report],
        [:detailed_report_view, detailed_report]]
    else
      :invalid
    end
  end

  def build_employee_time_report client_list, log_data, employee_names
    paths = []
    employee_names.each {|employee_name| paths << create_path(employee_name)}
    summary_timecode_report = @employees_report_handler.build_summary_timecode_report(log_data)
    summary_client_report = @employees_report_handler.build_summary_client_report(log_data, client_list)
    [[:employee_name_view, employee_names],
      [:employee_timecode_summary_report, summary_timecode_report],
      [:employee_client_summary_report, summary_client_report]]
  end

  private

  def create_path user_name
    user_name = user_name.split(' ').join('_').downcase
    File.expand_path("../../data/#{user_name}_log.csv", __FILE__)
  end

end
