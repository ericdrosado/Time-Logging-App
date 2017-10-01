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
    return File.expand_path("../../data/#{user_name}_log.csv", __FILE__)
  end

  def get_client_list
    client_list = []
    CSV.foreach(CLIENT_LIST_FILE) do |client|
      client_list << client.join('')
    end
    return client_list
  end

  def get_time_report user_name
    path = create_path(user_name)
    if File.file?(path)
      timecode_report = build_timecode_report(path)
      client_report = build_client_report(path)
      detailed_report = build_detailed_report(path)
      return [[:timecode_report_view, timecode_report],
              [:client_report_view, client_report],
              [:detailed_report_view, detailed_report]]
    else
      return "invalid"
    end
  end

  def build_timecode_report path
    billable_work_hours = 0
    nonbillable_work_hours = 0
    pto = 0
    CSV.foreach(path) do |row|
      month = get_month_from_data(row)
      if month === Date.today.month
        if row[2] == "Billable Work"
          billable_work_hours += row[1].to_i
        elsif row[2] == "Non-billable work"
          nonbillable_work_hours += row[1].to_i
        else row[2] == "PTO"
          pto += row[1].to_i
        end
      end
    end
    return "Total Billable Work Hours this month: #{billable_work_hours}\n"+
            "Total Non-billable Work Hours this month: #{nonbillable_work_hours}\n"+
            "Total PTO Hours this month: #{pto}"
  end

  def build_client_report path
    client_list = get_client_list
    client_list_hash = {}
    client_list.each {|client| client_list_hash[client] = 0}
    time_log_file = File.expand_path(path, __FILE__)
    CSV.foreach(time_log_file) do |row|
      month = get_month_from_data(row)
      if month === Date.today.month
        client_list.each do |client|
          client_list_hash[client] += row[1].to_i if client == row[3]
        end
      end
    end
    prepare_client_report(client_list_hash)
  end

  def prepare_client_report client_list_hash
    client_reports = []
    client_list_hash.each do |key, value|
      client_reports << "For #{key} you've worked #{value} hours this month"
    end
    client_reports.join("\n")
  end

  def build_detailed_report path
    month_of_reports = []
    time_log_file = File.expand_path(path, __FILE__)
    CSV.foreach(time_log_file) do |row|
      month = get_month_from_data(row)
      if month === Date.today.month
        month_of_reports << row.join(",")
      end
    end
    month_of_reports.sort_by {|date| date[0]}.join("\n")
  end

  def get_month_from_data row
    date = row[0].split('/')
    month = date[1].to_i
  end

end
