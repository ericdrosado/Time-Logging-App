require 'csv'

require_relative './employee_permissions'

class AdminPermissions < EmployeePermissions

  def add_employee name, permission
    full_name = name.split.map(&:capitalize).join(' ')
    employee_names = get_employee_names
    if @validator.valid_new_employee_entry?(name, permission, employee_names)
      CSV.open(EMPLOYEE_PERMISSIONS_FILE, "a+") do |csv|
          csv << [full_name,permission]
      end
    else
      return "invalid"
    end
  end

  def get_employee_names
    employee_names = []
    CSV.foreach(EMPLOYEE_PERMISSIONS_FILE) do |row|
      employee_names << row[0]
    end
    return employee_names
  end

  def add_client
  end

  def get_employee_time_report
  end

end
