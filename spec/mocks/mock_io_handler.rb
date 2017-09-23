class MockIOHandler

  attr_reader :output_called_with
  attr_writer :stubbed_value

  def print printable_item
    @output_called_with = printable_item
  end

  def get_input
    @stubbed_value
  end

end
