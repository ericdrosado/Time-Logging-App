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

  def add_client client_name
    client_names = get_client_names
    if @validator.valid_new_client_entry?(client_name, client_names)
      CSV.open(CLIENT_LIST_FILE, "a+") do |csv|
          csv << [client_name]
      end
    else
      return "invalid"
    end
  end

  def get_client_names
    client_names = []
    CSV.foreach(CLIENT_LIST_FILE) do |row|
      client_names << row[0]
    end
    return client_names
  end

  def get_employee_time_report
    employee_names = get_employee_names
    employee_names.shift
    paths = []
    employee_names.each {|employee_name| paths << create_path(employee_name)}
    summary_timecode_report = build_summary_timecode_report(paths)
    summary_client_report = build_summary_client_report(paths)
    return [[:employee_name_view, employee_names],
            [:employee_timecode_summary_report, summary_timecode_report],
            [:employee_client_summary_report, summary_client_report]]
  end

  def build_summary_timecode_report paths
    billable_work_hours = 0
    nonbillable_work_hours = 0
    pto = 0
    employee_timecode_logs = []
    paths.each do |path|
      if File.file?(path)
        CSV.foreach(path) do |row|
          month = get_month_from_data(row)
          if month === Date.today.month - 1
            if row[2] == "Billable Work"
              billable_work_hours += row[1].to_i
            elsif row[2] == "Non-billable work"
              nonbillable_work_hours += row[1].to_i
            else row[2] == "PTO"
              pto += row[1].to_i
            end
          end
        end
      end
      employee_timecode_logs << "Total Billable Work Hours last month: #{billable_work_hours}\n"+
                                "Total Non-billable Work Hours last month: #{nonbillable_work_hours}\n"+
                                "Total PTO Hours last month: #{pto}"
      billable_work_hours = 0
      nonbillable_work_hours = 0
      pto = 0
    end
    return employee_timecode_logs
  end

  def build_summary_client_report paths
    client_list = get_client_list
    client_list_hash = {}
    employee_client_logs = []
    paths.each do |path|
      client_list.each {|client| client_list_hash[client] = 0}
      if File.file?(path)
        CSV.foreach(path) do |row|
          month = get_month_from_data(row)
          if month === Date.today.month - 1
            client_list.each do |client|
              client_list_hash[client] += row[1].to_i if client == row[3]
            end
          end
        end
      end
      employee_client_logs << prepare_client_report(client_list_hash)
    end
    return employee_client_logs
  end

end
