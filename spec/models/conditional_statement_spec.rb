require File.dirname(__FILE__) + '/../spec_helper'

describe ConditionalStatement do

#  scenario :pages

  it "should not permit insantiation without a paramter" do
    lambda{conditional_statement = ConditionalStatement.new}.
        should raise_error(ArgumentError)
  end


  describe "with valid input" do
    [ { :input => "10 == 5", :output => "==" },
      { :input => "10 = 5", :output => "==" },
      { :input => "10 is 5", :output => "==" },
      { :input => "10 equals 5", :output => "==" },
      
      { :input => "10 != 5", :output => "!=" },
      { :input => "10 <> 5", :output => "!=" },
      { :input => "10 is_not 5", :output => "!=" },
      { :input => "10 not_equals 5", :output => "!=" },
      
      { :input => "10 =~ 5", :output => "=~" },
      { :input => "10 matches 5", :output => "=~" },
      { :input => "10 matches 5", :output => "=~" },
      
      { :input => "10 gt 5", :output => ">" },
      { :input => "10 GT 5", :output => ">" },
      
      { :input => "10 lt 5", :output => "<" },
      { :input => "10 LT 5", :output => "<" },
      
      { :input => "10 gte 5", :output => ">=" },
      { :input => "10 GTE 5", :output => ">=" },
      
      { :input => "10 lte 5", :output => "<=" },
      { :input => "10 LTE 5", :output => "<=" },
      
      { :input => "'test' blank?", :output => "blank?" },
      { :input => "'test' is_blank?", :output => "blank?" },
      
      { :input => "'test' empty?", :output => "empty?" },
      { :input => "'test' is_empty?", :output => "empty?" },
      
      { :input => "'test' exists?", :output => "exists?" }
    ].each do |current_cond|
      
      describe "(#{current_cond[:input]})" do
        
        before :all do
          @conditional_statement = ConditionalStatement.new(current_cond[:input])
        end

        it "should be valid" do
          @conditional_statement.should be_valid
        end
        
        it "should properly interpret the Comparison Type" do
          @conditional_statement.comparison_type.should == current_cond[:output]
        end
        
      end
      
    end
  
 
 
 
    [ { :input => "'string'", :output => "string" },
      { :input => " 'a string' ", :output => "a string" },
      { :input => "  'a very long string'", :output => "a very long string" },
      { :input => "'a string with it''s apostrophe'   ", :output => "a string with it's apostrophe" },
      { :input => %{'a string with odd characters ($#^*@\%&;:,.<>[]{}=+-_`~?)'}, :output => %{a string with odd characters ($#^*@\%&;:,.<>[]{}=+-_`~?)} },

      { :input => "false", :output => false },
      { :input => "False", :output => false },
      { :input => "FALSE", :output => false },
      { :input => "FaLsE", :output => false },
      { :input => "falsE", :output => false },

      { :input => "true", :output => true },
      { :input => "True", :output => true },
      { :input => "TRUE", :output => true },
      { :input => "TrUe", :output => true },
      { :input => "truE", :output => true },

      { :input => '/regexp/', :output => /regexp/ },
      { :input => '/\A((?:[^\s])*|(cat dog))$/   ', :output => /\A((?:[^\s])*|(cat dog))$/ },
      { :input => '   /\b(?:\d{1,3}\.){3}\d{1,3}\b/ ', :output => /\b(?:\d{1,3}\.){3}\d{1,3}\b/ },

      { :input => "10", :output => 10 },
      { :input => " -10  ", :output => -10 },
      { :input => "  5.25 ", :output => 5.25 },
      { :input => "-5.25   ", :output => -5.25 },
      { :input => "   +101.25", :output => 101.25 }
    ].each do |current_element|

      [ :primary_element, :comparison_element ].each do |element_type|

        # build the input string inserting the element in the proper location
        # depending on whether we're testing the primary or comparison element
        if element_type == :primary_element
          input_string = current_element[:input] + " == 'ignore this'"
        else
          input_string = "'ignore this' == " + current_element[:input]          
        end
        
        describe "where the #{element_type.to_s.humanize.titlecase} is a literal (#{input_string})" do

          before :all do
            @conditional_statement = ConditionalStatement.new(input_string)
          end
          
          it "should be valid" do
            @conditional_statement.should be_valid
          end
        
          it "should properly interpret the literal" do
            @conditional_statement.send(element_type).should == current_element[:output]
          end
          
        end
         
      end
    end

  end


  describe "with invalid input" do
    
    [ { :input => "", :err_msg => "invalid condition" },
      { :input => "a b c d", :err_msg => "invalid condition" },
      { :input => "'abc' /abc/", :err_msg => "invalid condition" },
      { :input => "100", :err_msg => "invalid condition" },
      { :input => "100 ??? 12", :err_msg => "invalid comparison (???) in condition" },
      { :input => "abc.def[ghi]", :err_msg => "could not evaluate \"abc.def[ghi]\" in condition" },
      { :input => "jabber = wocky", :err_msg => "could not evaluate \"jabber\" in condition" }
    ].each do |condition|
      
      describe "(#{condition[:input]})" do
        
        before :all do
          @conditional_statement = ConditionalStatement.new(condition[:input])
        end
        
        it "should not be valid" do
          @conditional_statement.should_not be_valid
        end
        
        it "should offer the proper err_msg" do
          @conditional_statement.err_msg.should == condition[:err_msg]
        end
        
      end

    end

  end


  describe "in a Page Context" do

    before :each do
      create_page "conditional_tags"
      @page = pages(:conditional_tags)
    end

  end
    
#  before(:each) do
#    @conditional_statement = ConditionalStatement.new
#  end
#
#  it "should be valid" do
#    @conditional_statement.should be_valid
#  end
end
