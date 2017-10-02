class Validator

  def validate_time_entry entry, client_list
    if client_list == nil
      return is_valid_date?(entry[0]) && is_not_future_date?(entry[0]) && is_a_number_other_than_0?(entry[1]) && is_a_valid_timecode?(entry[2])
    else
      return is_valid_date?(entry[0]) && is_not_future_date?(entry[0]) &&
              is_a_number_other_than_0?(entry[1]) && is_a_valid_timecode?(entry[2]) &&
              is_a_client?(entry[3], client_list)
    end
  end

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

  def is_a_valid_timecode? entry
    return entry == "Billable Work" || entry == "Non-billable Work" || entry == "PTO"
  end

  def is_a_client? entry, client_list
    return client_list.include?(entry)
  end

  def valid_new_employee_entry? name, permission, employee_names
    is_a_valid_name?(name) && is_a_valid_permission?(permission) && not_a_used_name?(name, employee_names)
  end

  def is_a_valid_name? name
    !! name.match(/(\A([A-Za-z]+)([\s]{1})([A-Za-z]+)\z)/)
  end

  def is_a_valid_permission? permission
    permission == 'admin' || permission == 'employee'
  end

  def not_a_used_name? name, employee_names
    employee_names.each do |employee_name|
      return false if employee_name == name
    end
    return true
  end

  def valid_new_client_entry? client, client_names
    client_names.each do |client_name|
      return false if client_name == client
    end
    return true
  end

end
