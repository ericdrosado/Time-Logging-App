require 'csv'

class EmployeePermissions

  EMPLOYEE_PERMISSIONS_FILE = File.expand_path('../../data/employee_permissions.csv', __FILE__)
  CLIENT_LIST_FILE = File.expand_path('../../data/client_list.csv', __FILE__)

  def initialize validator
    @validator = validator
  end

  def evaluate_permissions user_name
    user_type = get_user_permissions(user_name)
  end

  def get_user_permissions name
    CSV.foreach(EMPLOYEE_PERMISSIONS_FILE, headers: true) do |row|
      employee_permissions = row.to_hash
      if employee_permissions.values[0] == name
        return employee_permissions.values[1]
      end
    end
  end

  def enter_time entry, user_name, client_list = nil
    if @validator.validate_time_entry(entry, client_list)
      log_time(entry, user_name)
    else
      return 'invalid'
    end
  end

  def log_time entry, user_name
    path = create_path(user_name)
    time_log_file = File.expand_path(path, __FILE__)
    CSV.open(time_log_file, "a+") do |csv|
        csv << entry
    end
  end

  def create_path user_name
    user_name = user_name.split(' ')
    user_name = user_name.join('_').downcase
    return "../../data/#{user_name}_log.csv"
  end

  def get_client_list
    client_list = []
    CSV.foreach(CLIENT_LIST_FILE) do |client|
      client_list << client.join('')
    end
    return client_list
  end

  def get_time_report
  end

end
