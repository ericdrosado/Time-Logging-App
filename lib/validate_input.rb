class ValidateInput

  TIMECODES = ['Billable Work', 'Non-billable Work', 'PTO']
  EMPLOYEE_PERMISSIONS = ['admin', 'employee']

  def validate_time_entry entry, client_list
    if entry[2] == TIMECODES[0]
      is_valid_date?(entry[0]) && is_not_future_date?(entry[0]) &&
        is_a_number_other_than_0?(entry[1]) && is_a_valid_timecode?(entry[2]) &&
        is_a_client?(entry[3], client_list) && is_not_over_twenty_four_hours?(entry[1])
    else
      is_valid_date?(entry[0]) && is_not_future_date?(entry[0]) && is_a_number_other_than_0?(entry[1]) &&
        is_a_valid_timecode?(entry[2]) && is_not_over_twenty_four_hours?(entry[1])
    end
  end

  def valid_new_employee_entry? name, permission, employee_names
    is_a_valid_name?(name) && is_a_valid_permission?(permission) && not_a_used_name?(name, employee_names)
  end

  def valid_new_client_entry? client, client_names
    client_names.each do |client_name|
      return false if client == "" || client_name == client
    end
    true
  end

  private

  def is_valid_date? entry
    d, m, y = entry.split('/')
    Date.valid_date? y.to_i, m.to_i, d.to_i
  end

  def is_not_future_date? entry
    Date.parse(entry) <= Date.today
  end

  def is_a_number_other_than_0? entry
    !! entry.match(/\d+/) && entry != '0'
  end

  def is_not_over_twenty_four_hours? entry
    entry.to_i <= 24
  end

  def is_a_valid_timecode? entry
    TIMECODES.include?(entry)
  end

  def is_a_client? entry, client_list
    client_list.include?(entry)
  end

  def is_a_valid_name? name
    !! name.match(/(\A([A-Za-z]+)([\s]{1})([A-Za-z]+)\z)/)
  end

  def is_a_valid_permission? permission
    EMPLOYEE_PERMISSIONS.include?(permission)
  end

  def not_a_used_name? name, employee_names
    employee_names.each do |employee_name|
      return false if employee_name == name
    end
    true
  end

end
