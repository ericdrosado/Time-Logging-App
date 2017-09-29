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

end
