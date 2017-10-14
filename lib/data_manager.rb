class DataManager

  def initialize csv_reader_writer, validate_input
    @csv_rw = csv_reader_writer
    @validate_input = validate_input
  end

  EMPLOYEE_PERMISSIONS_FILE_PATH = '../../data/employee_permissions.csv'
  CLIENT_LIST_FILE_PATH = '../../data/client_list.csv'
  EMPLOYEE_PERMISSIONS = ['admin', 'employee']
  TIMECODES = ['Billable Work', 'Non-billable Work', 'PTO']

  def get_individual_user_data user_name
    user_name = user_name.split(' ').join('_').downcase
    if File.file?(File.expand_path("../../data/#{user_name}_log.csv", __FILE__))
      user_log_data = @csv_rw.csv_reader("../../data/#{user_name}_log.csv")
    else
      :invalid
    end
  end

  def get_employee_data
    employees = get_employee_names
    employee_logs = []
    employees.each do |user_name|
      user_name = user_name.split(' ').join('_').downcase
      if File.file?(File.expand_path("../../data/#{user_name}_log.csv", __FILE__))
        log = @csv_rw.csv_reader("../../data/#{user_name}_log.csv")
        employee_logs << log
      else
        @csv_rw.csv_writer([Date.today,'0','PTO',''], "../../data/#{user_name}_log.csv")
        log = @csv_rw.csv_reader("../../data/#{user_name}_log.csv")
        employee_logs << log
      end
    end
    employee_logs
  end

  def log_in name, time_logger, view_manager
    permissions = get_user_permissions(name)
    call_menu_options(permissions, time_logger, view_manager)
  end

  def enter_time entry, user_name, view_manager
    client_list = get_client_list
    entry = choose_client(entry, client_list, view_manager)
    if @validate_input.validate_time_entry(entry, client_list)
      user_name = user_name.split(' ').join('_').downcase
      @csv_rw.csv_writer(entry, "../../data/#{user_name}_log.csv")
    else
      :invalid
    end
  end

  def add_employee name, permission
    full_name = name.split.map(&:capitalize).join(' ')
    employee_names = get_employee_names
    if @validate_input.valid_new_employee_entry?(name, permission, employee_names)
      @csv_rw.csv_writer([name, permission], EMPLOYEE_PERMISSIONS_FILE_PATH)
    else
      :invalid
    end
  end

  def get_user_permissions name
    users = @csv_rw.csv_reader(EMPLOYEE_PERMISSIONS_FILE_PATH)
    users.each do |user|
      if user[0] == name
        return user[1]
      end
    end
    :invalid
  end

  def add_client client_name
    client_names = get_client_list
    if @validate_input.valid_new_client_entry?(client_name, client_names)
      @csv_rw.csv_writer([client_name], CLIENT_LIST_FILE_PATH)
    else
      :invalid
    end
  end

  def get_client_list
    client_list = @csv_rw.csv_reader(CLIENT_LIST_FILE_PATH)
    clients = client_list.join(",").split(",")
  end

  def get_employee_names
    employee_names = []
    users = @csv_rw.csv_reader(EMPLOYEE_PERMISSIONS_FILE_PATH)
    users.each {|employee| employee_names << employee[0]}
    employee_names
  end

  private

  def call_menu_options permissions, time_logger, view_manager
    if permissions == :invalid
      view_manager.invalid_name_view
      time_logger.run_logger
    elsif permissions == EMPLOYEE_PERMISSIONS[0]
      view_manager.get_view(:admin_options_view)
    else
      view_manager.get_view(:employee_options_view)
    end
  end

  def choose_client entry, client_list, view_manager
    if entry[2] == TIMECODES[0]
      view_manager.get_view(:client_view)
      client_list.each {|client| view_manager.get_parameter_view(:client_list_view, client)}
      entry << view_manager.get_input
    else
      entry << nil
    end
  end

end
