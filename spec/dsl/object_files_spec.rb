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
      @dsl.requires_rcons_version '2.0.0'

      Kernel.should have_received(:exit).with 1
    end

    it 'should exit if required version doesn\'t match `~>` operator' do
      @dsl.requires_rcons_version '~> 1.2.4'
      Kernel.should have_received(:exit).with 1
    end

    it 'should not exit on exact match of version' do
      @dsl.requires_rcons_version RCons::VERSION
      Kernel.should_not have_received(:exit)
    end

    it 'should not exit on match with `~>` operator' do
      @dsl.requires_rcons_version '~> 1.2.2'
      Kernel.should_not have_received :exit
    end
  end

  describe 'compiling' do
    before :each do
      Kernel.stub :exit
      $stdout.puts
      @dsl = RCons::DSL.new
      class RCons::Target
        attr_accessor :file_name, :name, :source_name
      end
    end

    it 'should recognize proper target filename for an object' do
      test_o = @dsl.object_file 'test'

      test_o.should be_kind_of RCons::Target
      test_o.name.should eq 'test'
      test_o.file_name.should eq 'test.o'
    end

    it 'should recognize proper source filename for an object' do
      test_o = @dsl.object_file 'test'

      test_o.should be_kind_of RCons::Target
      test_o.name.should eq 'test'
      test_o.source_name.should eq 'test.c'
    end
  end
end