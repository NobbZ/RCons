require 'rspec'

require 'rcons/dsl'

describe RCons::DSL do
  describe 'version matching' do
    before(:each) do
      Kernel.stub :exit
      $stdout.stub :puts
      stub_const 'RCons::VERSION', '1.2.3'
      @dsl = RCons::DSL.new
    end

    it 'should exit if required version is higher than RCons version' do
      @dsl.required_version '2.0.0'

      Kernel.should have_received(:exit).with 1
    end

    it 'should exit if required version doesn\'t match `~>` operator' do
      @dsl.required_version '~> 1.2.4'
      Kernel.should have_received(:exit).with 1
    end

    it 'should not exit on exact match of version' do
      @dsl.required_version RCons::VERSION
      Kernel.should_not have_received(:exit)
    end

    it 'should not exit on match with `~>` operator' do
      @dsl.required_version '~> 1.2.2'
      Kernel.should_not have_received :exit
    end
  end

  it 'should compile some sources' do
    pending 'carve out a proper test'
    #To change this template use File | Settings | File Templates.
    true.should == false
  end
end