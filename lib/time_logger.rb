class TimeLogger

  def initialize data_manager, report_builder, view_manager
    @data_manager = data_manager
    @report_builder = report_builder
    @view_manager = view_manager
  end

  OPTIONS = {'0' => :run_logger, '1' => :log_time, '2' => :get_log_report, '3' => :add_new_employee, '4' => :add_client, '5' => :get_employee_time_report}
  ALLOWED_PERMISSION = 'admin'

  def run_logger name = ''
    @view_manager.start_view
    name = @view_manager.get_input
    logged_in(name)
  end

  def logged_in name
    @data_manager.log_in(name, self, @view_manager)
    option = @view_manager.get_input
    if OPTIONS.keys.include?(option)
      send(OPTIONS[option], name)
    else
      evaluate_entry_status(:invalid, name)
    end
  end

  private

  def log_time name
    @view_manager.log_time_view
    log = @view_manager.get_input
    log == "" ? log_time : log = log.split(',')
    entry_status = @data_manager.enter_time(log, name, @view_manager)
    evaluate_entry_status(entry_status, name)
  end

  def get_log_report name
    @view_manager.clear_view
    log_data = @data_manager.get_individual_user_data(name)
    client_list = @data_manager.get_client_list
    report = @report_builder.build_user_report(client_list, log_data, name)
    report == :invalid ? @view_manager.get_prompt(:no_log) : report.each {|report_type| @view_manager.get_parameter_view(report_type[0], report_type[1])}
    evaluate_entry_status(report, name)
  end

  def add_new_employee name
    @view_manager.clear_view
    entry_status = evaluate_permissions(name)
    if entry_status == ALLOWED_PERMISSION
      @view_manager.get_view(:add_employee_view)
      new_employee_name = @view_manager.get_input
      @view_manager.get_prompt(:request_permission_type)
      permission = @view_manager.get_input
      entry_status = @data_manager.add_employee(new_employee_name, permission)
    end
    evaluate_entry_status(entry_status, name)
  end

  def add_client name
    @view_manager.clear_view
    entry_status = evaluate_permissions(name)
    if entry_status == ALLOWED_PERMISSION
      @view_manager.get_view(:add_client_view)
      client_name = @view_manager.get_input
      entry_status = @data_manager.add_client(client_name)
    end
    evaluate_entry_status(entry_status, name)
  end

  def get_employee_time_report name
    @view_manager.clear_view
    entry_status = evaluate_permissions(name)
    if entry_status == ALLOWED_PERMISSION
      client_list = @data_manager.get_client_list
      employee_names = @data_manager.get_employee_names
      log_data = @data_manager.get_employee_data
      report = @report_builder.build_employee_time_report(client_list, log_data, employee_names)
      @view_manager.clear_view()
      @view_manager.get_view(:employee_summary_report)
      employee_names = report[0]
      timecode_reports = report[1]
      client_reports = report[2]
      index = 0
      while employee_names[1].length > index
        @view_manager.get_parameter_view(employee_names[0], employee_names[1][index])
        @view_manager.get_parameter_view(timecode_reports[0], timecode_reports[1][index])
        @view_manager.get_parameter_view(client_reports[0], client_reports[1][index])
        index += 1
      end
    end
    evaluate_entry_status(entry_status, name)
  end

  def evaluate_entry_status entry_status, name
    if entry_status == :invalid
      @view_manager.get_prompt(:invalid_entry)
      logged_in(name)
    else
      @view_manager.get_prompt(:successful_operation)
      logged_in(name)
    end
  end

  def evaluate_permissions name
    permission = @data_manager.get_user_permissions(name)
    if permission == ALLOWED_PERMISSION
      permission
    else
      :invalid
    end
  end

end
