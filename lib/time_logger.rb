require 'csv'

class TimeLogger

  attr_reader :user_name

  def initialize admin_permissions, employee_permissions, logger_view
    @admin_permissions = admin_permissions
    @employee_permissions = employee_permissions
    @logger_view = logger_view
  end

  def start_logger
    @logger_view.clear_view()
    @logger_view.print_view(:welcome_view)
    call_options_view
  end

  def call_options_view
    user_type = get_permission_level
    options_view = user_type + '_options_view'
    @logger_view.print_view(options_view)
    send(user_type + '_options', options_view)
  end

  def get_permission_level
    user_type = nil
    while user_type == nil
      get_user_name
      user_type = @employee_permissions.evaluate_permissions(@user_name)
      @logger_view.get_prompt(:not_employee) if user_type == nil
    end
    return user_type
  end

  def get_user_name
    @logger_view.get_prompt(:request_name)
    @user_name = @logger_view.get_input
  end

  def employee_options options_view
    choice = @logger_view.get_input
    case choice
    when '0'
      start_logger
    when '1'
      enter_time(@employee_permissions, options_view, 'employee_options')
    when '2'
      report = @employee_permissions.get_time_report
      #print_report_view
      employee_options(options_view)
    else
      invalid_entry(options_view, 'employee_options')
    end
  end

  def admin_options options_view
    choice = @logger_view.get_input
    case choice
    when '0'
      start_logger
    when '1'
      enter_time(@admin_permissions, options_view, 'admin_options')
    when '2'
      report = @admin_permissions.get_time_report
      #print_report_view
      admin_options(options_view)
    when '3'
      employee_name = @logger_view.get_input
      @admin_permissions.add_employee(employee_name)
      admin_options(options_view)
    when '4'
      client_name = @logger_view.get_input
      @admin_permissions.add_client
      admin_options(options_view)
    when '5'
      report = @admin_permissions.get_employee_time_report
      #print_report_view
      admin_options(options_view)
    else
      invalid_entry(options_view, 'admin_options')
    end
  end

  def enter_time permissions, options_view, options
    entry = get_log_entry
    entry_status = log_entry(entry, permissions)
    evaluate_entry_status(entry_status, options_view, options)
  end

  def get_log_entry
    @logger_view.clear_view()
    @logger_view.print_view(:time_entry_view)
    @logger_view.get_prompt(:request_time_entry)
    entry = @logger_view.get_input
    entry == "" ? get_log_entry : entry = entry.split(',')
  end

  def log_entry entry, permission
    if entry[2] == 'Billable Work'
      client_list = permission.get_client_list
      entry_with_client = choose_client(entry, client_list)
      entry_status = permission.enter_time(entry_with_client, @user_name, client_list)
    else
      entry_status = permission.enter_time(entry, @user_name)
    end
  end

  def choose_client entry, client_list
    @logger_view.print_view(:client_view)
    client_list.each {|client| @logger_view.print_parameter_view(:client_list_view, client)}
    entry << @logger_view.get_input
  end

  def invalid_entry options_view, options
    entry_status = 'invalid'
    evaluate_entry_status(entry_status, options_view, options)
  end

  def evaluate_entry_status entry_status, options_view, options
    if entry_status == 'invalid'
      @logger_view.clear_view()
      @logger_view.print_view(options_view)
      @logger_view.get_prompt(:invalid_entry)
      send(options, options_view)
    else
      @logger_view.clear_view()
      @logger_view.get_prompt(:successful_operation)
      @logger_view.print_view(options_view)
      send(options, options_view)
    end
  end

end
