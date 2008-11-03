require File.dirname(__FILE__) + '/../spec_helper'


module ConditionalTags
  describe ConditionalStatement do
    
    it "should not permit insantiation without a paramter" do
      lambda{conditional_statement = ConditionalStatement.new}.
          should raise_error(ArgumentError)
    end
  
  
  
  
    describe "with valid input" do
      [ { :input => "10 == 5", :output => "==" },
        { :input => "10 = 5", :output => "==" },
        { :input => "10 is 5", :output => "==" },
        { :input => "10 equals 5", :output => "==" },
        
        { :input => "10 =~ 5", :output => "=~" },
        { :input => "10 matches 5", :output => "=~" },
        
        { :input => "10 includes 5", :output => "(&&)" },
        { :input => "10 includes-all 5", :output => "(&&)" },
        { :input => "10 includes-any 5", :output => "(||)" },
        
        { :input => "10 gt 5", :output => ">" },
        { :input => "10 GT 5", :output => ">" },
        
        { :input => "10 lt 5", :output => "<" },
        { :input => "10 LT 5", :output => "<" },
        
        { :input => "10 gte 5", :output => ">=" },
        { :input => "10 GTE 5", :output => ">=" },
        
        { :input => "10 lte 5", :output => "<=" },
        { :input => "10 LTE 5", :output => "<=" },
        
        { :input => "'test' blank?", :output => "blank?" },
        { :input => "'test' is-blank?", :output => "blank?" },
        
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
        { :input => "   +101.25", :output => 101.25 },
  
        { :input => "[]", :output => [] },
        { :input => "[10, 11, 12]", :output => [10, 11, 12] },
        { :input => "['a', 'b' ,'c']", :output => ['a', 'b', 'c'] },
        { :input => "[true, FALSE, tRuE]", :output => [true, false, true] },
        { :input => "[nil, null , NOTHING]", :output => [nil, nil, nil] },
        { :input => "[10, 'b', TRUE]", :output => [10, 'b', true] }
      
      ].each do |current_element|
        [ :primary_element, :comparison_element ].each do |element_type|
  
          input_string = build_input_using(current_element[:input], element_type)
  
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
  
  
  
    
    describe "with invalid conditions" do
      [ "",
        "a b c d",
        "100",
      ].each do |condition|
        
        describe "(#{condition})" do
          
          before :all do
            @conditional_statement = ConditionalStatement.new(condition)
          end
          
          it "should not be valid" do
            @conditional_statement.should_not be_valid
          end
          
          it "should produce the proper error message" do
            @conditional_statement.err_msg.should == "invalid condition \"#{condition}\""
          end
          
        end
    
      end
    end
    
    
    
    
    describe "with malformed conditions" do
      [ { :input => "'abc' /abc/ 12", :comparison => "/abc/" },
        { :input => "100 ??? 12", :comparison => "???"  },
      ].each do |condition|
        
        describe "(#{condition[:input]})" do
          
          before :all do
            @conditional_statement = ConditionalStatement.new(condition[:input])
          end
          
          it "should not be valid" do
            @conditional_statement.should_not be_valid
          end
          
          it "should produce the proper error message" do
            @conditional_statement.err_msg.should ==
                "invalid comparison \"#{condition[:comparison]}\" in condition \"#{condition[:input]}\""
          end
          
        end
        
      end
    end
    
    
    
    
    [ :primary_element, :comparison_element].each do |element_type|
  
      [ "['g' 'h' 'i']",
        "[ a ]",
        "['a' ,  a  ]",
        "[true\t 10]"
      ].each do |element|
  
        describe "with conditions having malformed array elements" do
  
          before :each do
            @input_string = build_input_using(element, element_type)
            @conditional_statement = ConditionalStatement.new(@input_string)
          end
          
          it "should not be valid (using: #{@input_string})" do
            @conditional_statement.should_not be_valid
          end
          
          it "should produce the proper error message" do
            @conditional_statement.err_msg.should == 
                "invalid list \"#{element}\" in condition \"#{@input_string}\""
          end
          
        end
      end
        
        
        
        
      [ {:input => "abc.def['g' 'h' 'i']", :array => "['g' 'h' 'i']"},
        {:input => "abc[a]", :array => "[a]"},
        {:input => "abc['a', a]", :array => "['a', a]"},
        {:input => "abc[true\t 10]", :array => "[true\t 10]"}
      ].each do |element|
  
        describe "with conditions having symbolic elements with malformed array elements" do
  
          before :each do
            @input_string = build_input_using(element[:input], element_type)
            @conditional_statement = ConditionalStatement.new(@input_string)
          end
          
          it "should not be valid (using: #{@input_string})" do
            @conditional_statement.should_not be_valid
          end
          
          it "should produce the proper error message" do
            @conditional_statement.err_msg.should == 
                "invalid list \"#{element[:array]}\" in condition \"#{@input_string}\""
          end
          
        end
      end
      
      
      
      
      [ { :input => "abc.def[10]", :identifier => "abc.def" },
        { :input => "jabber", :identifier => "jabber" },
        { :input => "jub.jub['bird']", :identifier => "jub.jub" }
      ].each do |element|
            
        describe "with conditions containing unknown symbolic element identifiers" do
  
          before :all do
            @input_string = build_input_using(element[:input], element_type)
            @conditional_statement = ConditionalStatement.new(@input_string)
          end
          
          it "should not be valid (using: #{@input_string})" do
            @conditional_statement.should_not be_valid
          end
          
          it "should produce the proper error message" do
            @conditional_statement.err_msg.should == 
                "Error in condition \"#{@input_string}\" (cannot interpret element \"#{element[:identifier]}\")"
          end
            
        end
          
      end
  
    
    end
  
  end
end