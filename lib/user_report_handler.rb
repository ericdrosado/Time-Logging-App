class UserReportHandler

  TIMECODES = ['Billable Work', 'Non-billable Work', 'PTO']

  def build_timecode_report log_data
    billable_work_hours = 0
    nonbillable_work_hours = 0
    pto = 0
    log_data.each do |log|
      month = get_month_from_data(log)
      if month === Date.today.month
        if log[2] == TIMECODES[0]
          billable_work_hours += log[1].to_i
        elsif log[2] == TIMECODES[1]
          nonbillable_work_hours += log[1].to_i
        else log[2] == TIMECODES[2]
          pto += log[1].to_i
        end
      end
    end
    "Total Billable Work Hours this month: #{billable_work_hours}\n"+
      "Total Non-billable Work Hours this month: #{nonbillable_work_hours}\n"+
      "Total PTO Hours this month: #{pto}"
  end

  def build_client_report client_list, log_data
    client_list_hash = {}
    client_list.each {|client| client_list_hash[client] = 0}
    log_data.each do |log|
      month = get_month_from_data(log)
      if month === Date.today.month
        client_list.each do |client|
          client_list_hash[client] += log[1].to_i if client == log[3]
        end
      end
    end
    prepare_client_report(client_list_hash)
  end

  def build_detailed_report log_data
    month_of_reports = []
    log_data.each do |log|
      month = get_month_from_data(log)
      if month === Date.today.month
        month_of_reports << log.join(",")
      end
    end
    month_of_reports.sort_by {|date| date}.join("\n")
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

end
