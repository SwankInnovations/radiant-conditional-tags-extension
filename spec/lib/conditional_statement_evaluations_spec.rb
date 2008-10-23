require File.dirname(__FILE__) + '/../spec_helper'


module ConditionalTags

  describe ConditionalStatement do
  
    describe "when using \"==\"" do
      
      it "should be valid and true if two equal numbers are compared" do
        conditional_statement = ConditionalStatement.new("1 == 1.00")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if two unequal numbers are compared" do
        conditional_statement = ConditionalStatement.new("1 == 2")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and true if two equal strings are compared" do
        conditional_statement = ConditionalStatement.new("'string' = 'string'")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if two unequal strings are compared" do
        conditional_statement = ConditionalStatement.new("'string' = 'different string'")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and true if two equal regexp are compared" do
        conditional_statement = ConditionalStatement.new("/abc/ equals /abc/")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if two unequal regexp are compared" do
        conditional_statement = ConditionalStatement.new("/abc/ equals /abcd/")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and true if two equal booleans are compared" do
        conditional_statement = ConditionalStatement.new("false is false")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if two unequal booleans are compared" do
        conditional_statement = ConditionalStatement.new("true is false")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and true if nil is compared to nil" do
        conditional_statement = ConditionalStatement.new("nil is nothing")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if a number and a boolean are compared" do
        conditional_statement = ConditionalStatement.new("1 == true")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a number and a string are compared" do
        conditional_statement = ConditionalStatement.new("1 == '1'")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a number and nil are compared" do
        conditional_statement = ConditionalStatement.new("1 == null")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a number and an array are compared" do
        conditional_statement = ConditionalStatement.new("1 == [1]")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a string and an array are compared" do
        conditional_statement = ConditionalStatement.new("'1' == [1]")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a nil and an array are compared" do
        conditional_statement = ConditionalStatement.new("nil == []")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a boolean and an array are compared" do
        conditional_statement = ConditionalStatement.new("false == [false]")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a nil and an array are compared" do
        conditional_statement = ConditionalStatement.new("nil == []")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a regexp and an array are compared" do
        conditional_statement = ConditionalStatement.new("/abc/ == ['abc']")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a boolean and a string are compared" do
        conditional_statement = ConditionalStatement.new("false == 'false'")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a nil and a string are compared" do
        conditional_statement = ConditionalStatement.new("nil == ''")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a regexp and a string are compared" do
        conditional_statement = ConditionalStatement.new("/abc/ == 'abc'")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
    end
  
  
  
  
    describe "when using \"=~\"" do
      
      it "should be valid and true if a regexp and a matching string are compared" do
        conditional_statement = ConditionalStatement.new("/colou?r/ =~ 'my color'")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and true if a string and a matching regexp are compared" do
        conditional_statement = ConditionalStatement.new("'my color' matches /colou?r/")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and true if a regexp and a non-matching string are compared" do
        conditional_statement = ConditionalStatement.new("/colou?r/ =~ 'is red'")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
    
    
      it "should be invalid and provide the proper err_msg if valid types aren't compared" do
        conditional_statement = ConditionalStatement.new("'weird' matches '15'")
        conditional_statement.should_not be_valid
        conditional_statement.err_msg.should == 
            %{the elements in condition "'weird' matches '15'" cannot be compared using matching}
      end
    
    
      it "should be invalid if a regexp and number are compared" do
        conditional_statement = ConditionalStatement.new("/colou?r/ matches 15")
        conditional_statement.should_not be_valid
      end
  
  
      it "should be valid and false if a regexp and nil are compared (odd)" do
        conditional_statement = ConditionalStatement.new("'string' =~ 15")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
    
    
      it "should be valid and false if a string and a number are compared (really odd)" do
        conditional_statement = ConditionalStatement.new("'string' =~ 15")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
    
    end
  
  
  
  
    describe "when using \"gt\"" do
      
      it "should be valid and true if a larger number is compared against a smaller" do
        conditional_statement = ConditionalStatement.new("10 gt 5")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if a smaller number is compared against a larger" do
        conditional_statement = ConditionalStatement.new("5 gt 10")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a number is compared against an equal number" do
        conditional_statement = ConditionalStatement.new("5 gt 5")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be invalid and provide the proper err_msg if valid types aren't compared" do
        conditional_statement = ConditionalStatement.new("5 gt 'trees'")
        conditional_statement.should_not be_valid
        conditional_statement.err_msg.should == 
            %{the elements in condition "5 gt 'trees'" cannot be compared using greater-than}
      end
    
    
    end    
  
  
  
  
    describe "when using \"gte\"" do
      
      it "should be valid and true if a larger number is compared against a smaller" do
        conditional_statement = ConditionalStatement.new("10 gte 5")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if a smaller number is compared against a larger" do
        conditional_statement = ConditionalStatement.new("5 gte 10")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and true if a number is compared against an equal number" do
        conditional_statement = ConditionalStatement.new("5 gte 5")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be invalid and provide the proper err_msg if valid types aren't compared" do
        conditional_statement = ConditionalStatement.new("5 gte 'trees'")
        conditional_statement.should_not be_valid
        conditional_statement.err_msg.should == 
            %{the elements in condition "5 gte 'trees'" cannot be compared using greater-than-or-equal}
      end
    
    end    
  
  
  
  
    describe "when using \"lt\"" do
      
      it "should be valid and true if a larger number is compared against a smaller" do
        conditional_statement = ConditionalStatement.new("5 lt 10")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if a smaller number is compared against a larger" do
        conditional_statement = ConditionalStatement.new("10 lt 5")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and false if a number is compared against an equal number" do
        conditional_statement = ConditionalStatement.new("5 lt 5")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be invalid and provide the proper err_msg if valid types aren't compared" do
        conditional_statement = ConditionalStatement.new("5 lt 'trees'")
        conditional_statement.should_not be_valid
        conditional_statement.err_msg.should == 
            %{the elements in condition "5 lt 'trees'" cannot be compared using less-than}
      end
    
    end    
  
  
  
  
    describe "when using \"lte\"" do
      
      it "should be valid and true if a larger number is compared against a smaller" do
        conditional_statement = ConditionalStatement.new("5 lte 10")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if a smaller number is compared against a larger" do
        conditional_statement = ConditionalStatement.new("10 lte 5")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
      
      
      it "should be valid and true if a number is compared against an equal number" do
        conditional_statement = ConditionalStatement.new("5 lte 5")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be invalid and provide the proper err_msg if valid types aren't compared" do
        conditional_statement = ConditionalStatement.new("5 lte 'trees'")
        conditional_statement.should_not be_valid
        conditional_statement.err_msg.should == 
            %{the elements in condition "5 lte 'trees'" cannot be compared using less-than-or-equal}
      end
    
    end    
  
  
  
    describe "when using \"exists?\"" do
      
      it "should be valid and true if the primary element is not nil" do
        conditional_statement = ConditionalStatement.new("5 exists?")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_true
      end
      
      
      it "should be valid and false if the primary element is nil" do
        conditional_statement = ConditionalStatement.new("nil exists?")
        conditional_statement.should be_valid
        conditional_statement.true?.should be_false
      end
  
      
      it "should be invalid and provide the proper err_msg if a comparison element is provided" do
        conditional_statement = ConditionalStatement.new("10 exists? 'tree'")
        conditional_statement.should_not be_valid
        conditional_statement.err_msg.should == 
            %{the "exists?" comparison in condition "10 exists? 'tree'" may not have a following comparison element}
      end
      
      
    end
  
  end
  
end