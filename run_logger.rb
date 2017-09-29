require_relative 'lib/admin_permissions'
require_relative 'lib/employee_permissions'
require_relative 'lib/io_handler'
require_relative 'lib/logger_view'
require_relative 'lib/prompter'
require_relative 'lib/time_logger'
require_relative 'lib/validator'

io_handler = IOHandler.new
prompter = Prompter.new
logger_view = LoggerView.new(io_handler, prompter)
validator = Validator.new
admin_permissions = AdminPermissions.new(validator)
employee_permissions = EmployeePermissions.new(validator)
time_logger = TimeLogger.new(admin_permissions, employee_permissions, logger_view)
time_logger.start_logger
