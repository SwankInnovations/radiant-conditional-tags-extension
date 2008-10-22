require File.dirname(__FILE__) + '/../spec_helper'


describe ConditionalStatement do

  describe "when using \"==\"" do
    
    it "should return true if two equal numbers are compared" do
      conditional_statement = ConditionalStatement.new("1 == 1.00")
      conditional_statement.result.should == true
    end
    
    
    it "should return false if two unequal numbers are compared" do
      conditional_statement = ConditionalStatement.new("1 == 2")
      conditional_statement.result.should == false
    end
    
    
    it "should return true if two equal strings are compared" do
      conditional_statement = ConditionalStatement.new("'string' = 'string'")
      conditional_statement.result.should == true
    end
    
    
    it "should return false if two unequal strings are compared" do
      conditional_statement = ConditionalStatement.new("'string' = 'different string'")
      conditional_statement.result.should == false
    end
    
    
    it "should return true if two equal regexp are compared" do
      conditional_statement = ConditionalStatement.new("/abc/ equals /abc/")
      conditional_statement.result.should == true
    end
    
    
    it "should return false if two unequal regexp are compared" do
      conditional_statement = ConditionalStatement.new("/abc/ equals /abcd/")
      conditional_statement.result.should == false
    end
    
    
    it "should return true if two equal booleans are compared" do
      conditional_statement = ConditionalStatement.new("false is false")
      conditional_statement.result.should == true
    end
    
    
    it "should return false if two unequal booleans are compared" do
      conditional_statement = ConditionalStatement.new("true is false")
      conditional_statement.result.should == false
    end
    
    
    it "should return true if nil is compared to nil" do
      conditional_statement = ConditionalStatement.new("nil is nothing")
      conditional_statement.result.should == true
    end
    
    
    it "should return false if a number and a boolean are compared" do
      conditional_statement = ConditionalStatement.new("1 == true")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a number and a string are compared" do
      conditional_statement = ConditionalStatement.new("1 == '1'")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a number and nil are compared" do
      conditional_statement = ConditionalStatement.new("1 == null")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a number and an array are compared" do
      conditional_statement = ConditionalStatement.new("1 == [1]")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a string and an array are compared" do
      conditional_statement = ConditionalStatement.new("'1' == [1]")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a nil and an array are compared" do
      conditional_statement = ConditionalStatement.new("nil == []")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a boolean and an array are compared" do
      conditional_statement = ConditionalStatement.new("false == [false]")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a nil and an array are compared" do
      conditional_statement = ConditionalStatement.new("nil == []")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a regexp and an array are compared" do
      conditional_statement = ConditionalStatement.new("/abc/ == ['abc']")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a boolean and a string are compared" do
      conditional_statement = ConditionalStatement.new("false == 'false'")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a nil and a string are compared" do
      conditional_statement = ConditionalStatement.new("nil == ''")
      conditional_statement.result.should == false
    end
    
    
    it "should return false if a regexp and a string are compared" do
      conditional_statement = ConditionalStatement.new("/abc/ == 'abc'")
      conditional_statement.result.should == false
    end
    
  end




  describe "when using \"=~\"" do
    
    it "should return true if a regexp and a matching string are compared" do
      conditional_statement = ConditionalStatement.new("/colou?r/ =~ 'my color'")
      conditional_statement.result.should == true
    end
    
    
    it "should return true if a string and a matching regexp are compared" do
      conditional_statement = ConditionalStatement.new("'my color' matches /colou?r/")
      conditional_statement.result.should == true
    end
    
    
    it "should return true if a regexp and a non-matching string are compared" do
      conditional_statement = ConditionalStatement.new("/colou?r/ =~ 'is red'")
      conditional_statement.result.should == false
    end
  
  
    it "should be provide the proper err_msg if valid types aren't compared" do
      conditional_statement = ConditionalStatement.new("'weird' matches '15'")
      conditional_statement.err_msg.should == 
          %{element types in condition "'weird' =~ '15'" cannot be compared using matching}
    end
  
  
    it "should be invalid if a regexp and number are compared" do
      conditional_statement = ConditionalStatement.new("/colou?r/ matches 15")
      conditional_statement.should_not be_valid
    end


    it "should return false if a regexp and nil are compared (odd)" do
      conditional_statement = ConditionalStatement.new("'string' =~ 15")
      conditional_statement.result.should == false
    end
  
  
    it "should return false if a string and a number are compared (really odd)" do
      conditional_statement = ConditionalStatement.new("'string' =~ 15")
      conditional_statement.result.should == false
    end
  
  end
    

end