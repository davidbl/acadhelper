require File.join(File.dirname(__FILE__), ".." ,"spec_helper" )
require 'rubygems'
require 'acadhelper'
include AcadHelper

module AcadHelper
	describe "editor functions" do
		before(:each) do
			@app = Aas::Application
			@ed = Aas::Application.DocumentManager.MdiActiveDocument.Editor
		end
		
		it "should have get_input function" do
			@result = mock("result",:Status => Aei::PromptStatus.OK, :Value => 5) 
			#@ed.stub!(:GetDouble)
			@ed.should_receive(:GetDouble).and_return(@result)
			get_input(:Double,"prompt").should == 5
		end
		
		it "should build the correct options" do
			opts = build_option(:Double, "Please Enter A Double", :AllowNegative => true, :AllowZero => true)
			opts.AllowNegative.should be_true
			opts.AllowZero.should be_true
			opts.class.should == Autodesk::AutoCAD::EditorInput::PromptDoubleOptions
		end
		
		it "should notify about invalid options but not fail" do
			Kernel.stub!(:warn)
			Kernel.should_receive(:warn).with("\nUnable to set option Foo for GetDouble ")
			opts = build_option(:Double, "Please Enter A Double", :AllowNegative => true, :Foo => true)
			opts.AllowNegative.should be_true
			opts.class.should == Autodesk::AutoCAD::EditorInput::PromptDoubleOptions
		end
		
		it "should use the default prompt" do
			opts = build_option(:Double)
			opts.Message.should == "\nPlease enter a Double"
			opts = build_option(:String)
			opts.Message.should == "\nPlease enter a String"
		end
		
		it "should return the correct value based on the input type" do
			inputs = [:Distance, :Double, :Integer, :Point, :String, :Entity]
			inputs.each do |input|
				result = mock("result",:Status => Aei::PromptStatus.OK, :Value => input, :StringResult => input, :ObjectId => input) 
				param = "Get#{input.to_s}".to_sym
				@ed.stub!(param)
				@ed.should_receive(param).and_return(result)
				get_input(input,"prompt").should == input
			end
		end
		
		it "should return the correct value when input type is keyword" do
			@result = mock("result",:Status => Aei::PromptStatus.Keyword, :StringResult => "foo") 
			#@ed.stub!(:GetDouble)
			@ed.should_receive(:GetKeyword).and_return(@result)
			get_input(:Keyword,"prompt").should == "foo"
		end
				
	end
	
	describe "selection set filter builder" do
		it "should be a class " do
			ss_filter = SsFilter.new
		end
		
		it "should allow the user to add elements one at a time" do
			ss_filter = SsFilter.new
			ss_filter.Layer = "test_layer"
			ss_filter.Type = "line"
			ss_filter.Layer.should == "test_layer"
			ss_filter.Type.should == "line"
		end
		
		it "should raise if element is invalid" do
			ss_filter = SsFilter.new
			lambda {ss_filter.Foo = "bar"}.should raise_error
		end
		
		it "should have a filter method" do
			ss_filter = SsFilter.new
			ss_filter.filter.class.should == Aei::SelectionFilter
		end
		
	end
	
end