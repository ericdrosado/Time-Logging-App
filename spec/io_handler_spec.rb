require_relative '../lib/io_handler.rb'

describe 'IOHandler' do

  before {@io_handler = IOHandler.new}

  describe '#print' do
    it 'will print to terminal' do
      expect{@io_handler.print('Welcome!')}.to output.to_stdout
    end
  end

  describe '#get_input' do
    it 'will equal input' do
      expect(@io_handler).to receive(:get_input).and_return('test')
      expect(@io_handler.get_input).to eq 'test'
    end
  end

end
