require 'spec_helper'
describe 'y10k' do

  context 'with defaults for all parameters' do
    it { should contain_class('y10k') }
  end
end
