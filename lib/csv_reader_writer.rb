require 'csv'

class CSVReaderWriter

  def csv_writer entry, path
    CSV.open(File.expand_path(path, __FILE__), "a+") do |csv|
        csv << entry
    end
  end

  def csv_reader path
    csv_data = []
    CSV.foreach(File.expand_path(path, __FILE__)) do |row|
      csv_data << row
    end
    csv_data
  end

end
