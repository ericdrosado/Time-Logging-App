class EmployeesReportHandler

  TIMECODES = ['Billable Work', 'Non-billable Work', 'PTO']

  def build_summary_timecode_report log_data
    billable_work_hours = 0
    nonbillable_work_hours = 0
    pto = 0
    employee_timecode_logs = []
    log_data.each do |log|
      timecode_values = sum_timecode_hours(log)
      billable_work_hours = timecode_values[0] + billable_work_hours
      nonbillable_work_hours = timecode_values[1] + nonbillable_work_hours
      pto = timecode_values[2] + pto
      employee_timecode_logs << "Total Billable Work Hours last month: #{billable_work_hours}\n"+
                                "Total Non-billable Work Hours last month: #{nonbillable_work_hours}\n"+
                                "Total PTO Hours last month: #{pto}"
      billable_work_hours = 0
      nonbillable_work_hours = 0
      pto = 0
    end
    employee_timecode_logs
  end

  def build_summary_client_report log_data, client_list
    client_list_hash = {}
    employee_client_logs = []
    log_data.each do |log|
      client_list_hash = sum_client_hours(log, client_list)
      employee_client_logs << prepare_client_report(client_list_hash)
    end
    employee_client_logs
  end

  private

  def prepare_client_report client_list_hash
    client_reports = []
    client_list_hash.each do |key, value|
      client_reports << "For #{key} employee worked #{value} hours"
    end
    client_reports.join("\n")
  end

  def get_month_from_data log
    date = log[0].split('/')
    month = date[1].to_i
  end

  def sum_timecode_hours log
    billable_work_hours = 0
    nonbillable_work_hours = 0
    pto = 0
    log.each do |log|
      month = get_month_from_data(log)
      if month === Date.today.month - 1
        if log[2] == TIMECODES[0]
          billable_work_hours += log[1].to_i
        elsif log[2] == TIMECODES[1]
          nonbillable_work_hours += log[1].to_i
        else log[2] == TIMECODES[2]
          pto += log[1].to_i
        end
      end
    end
    [billable_work_hours, nonbillable_work_hours, pto]
  end

  def sum_client_hours log, client_list
    client_list_hash = {}
    client_list.each {|client| client_list_hash[client] = 0}
    log.each do |log|
      month = get_month_from_data(log)
      if month === Date.today.month - 1
        client_list.each do |client|
          client_list_hash[client] += log[1].to_i if client == log[3]
        end
      end
    end
    client_list_hash
  end

end
