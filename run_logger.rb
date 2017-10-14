require './lib/csv_reader_writer'
require './lib/employees_report_handler'
require './lib/user_report_handler'
require './lib/data_manager'
require './lib/io_handler'
require './lib/menu_views'
require './lib/report_builder'
require './lib/time_logger'
require './lib/validate_input'
require './lib/view_manager'
require './lib/view_prompts'

csv_reader_writer = CSVReaderWriter.new
validate_input = ValidateInput.new
data_manager = DataManager.new(csv_reader_writer, validate_input)
employees_report_handler = EmployeesReportHandler.new
user_report_handler = UserReportHandler.new
report_builder = ReportBuilder.new(employees_report_handler, user_report_handler)
io_handler = IOHandler.new
menu_views = MenuViews.new
view_prompts = ViewPrompts.new
view_manager = ViewManager.new(io_handler, menu_views, view_prompts)
time_logger = TimeLogger.new(data_manager, report_builder, view_manager)

time_logger.run_logger
