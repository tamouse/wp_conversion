require 'spec_helper'

describe WpConversion do
  it 'should have a version number' do
    WpConversion::VERSION.should_not be_nil
  end
  it 'should respond to :run' do
    WpConversion.should respond_to(:run)
  end
end
