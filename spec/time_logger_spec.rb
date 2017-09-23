require_relative '../lib/admin_permissions'
require_relative '../lib/employee_permissions'
require_relative './mocks/mock_io_handler'
require_relative '../lib/logger_view'
require_relative '../lib/prompter'
require_relative '../lib/time_logger'

describe 'TimeLogger' do

  before do
    mock_io_handler = MockIOHandler.new
    prompter = Prompter.new
    @logger_view = LoggerView.new(mock_io_handler, prompter)
    admin_permissions = AdminPermissions.new
    employee_permissions = EmployeePermissions.new
    @time_logger = TimeLogger.new(admin_permissions, employee_permissions, @logger_view)
  end

end
