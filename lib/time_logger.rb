require 'csv'

class TimeLogger

  EMPLOYEE_PERMISSIONS_FILE = File.expand_path('../../data/employee_permissions.csv', __FILE__)

  def initialize(admin_permissions, employee_permissions, logger_view)
    @admin_permissions = admin_permissions
    @employee_permissions = employee_permissions
    @logger_view = logger_view
  end

  def start_logger
    @logger_view.clear_view()
    @logger_view.print_view(:welcome_view)
    user_type = determine_user_permissions
    user_type == "admin" ? user = @admin_permissions : user = @employee_permissions
    @logger_view.print_view(user_type + "_options_view")
  end

  private

  def determine_user_permissions
    user_type = nil
    while user_type == nil
      name = get_user_name
      user_type = get_user_type_by_name(name)
    end
    return user_type
  end

  def get_user_name
    @logger_view.get_prompt(:request_name)
    return @logger_view.get_input
  end

  def get_user_type_by_name name
    user_type = get_user_permissions(name)
    if user_type == nil
      @logger_view.get_prompt(:not_employee)
    end
    return user_type
  end

  def get_user_permissions name
    CSV.foreach(EMPLOYEE_PERMISSIONS_FILE, headers: true) do |row|
      employee_permissions = row.to_hash
      if employee_permissions.values[0] == name
        return employee_permissions.values[1]
      end
    end
  end

end
