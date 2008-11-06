require File.dirname(__FILE__) + '/../spec_helper'


module ConditionalTags

  describe ConditionalStatement do

    describe "when using \"==\"" do

      it "should be true if two equal numbers are compared" do
        conditional_statement = ConditionalStatement.new("1 == 1.00")
        conditional_statement.true?.should be_true
      end


      it "should be false if two unequal numbers are compared" do
        conditional_statement = ConditionalStatement.new("1 == 2")
        conditional_statement.true?.should be_false
      end


      it "should be true if two equal strings are compared" do
        conditional_statement = ConditionalStatement.new("'string' = 'string'")
        conditional_statement.true?.should be_true
      end


      it "should be false if two unequal strings are compared" do
        conditional_statement = ConditionalStatement.new("'string' = 'different string'")
        conditional_statement.true?.should be_false
      end


      it "should be true if two equal regexp are compared" do
        conditional_statement = ConditionalStatement.new("/abc/ equals /abc/")
        conditional_statement.true?.should be_true
      end


      it "should be false if two unequal regexp are compared" do
        conditional_statement = ConditionalStatement.new("/abc/ equals /abcd/")
        conditional_statement.true?.should be_false
      end


      it "should be true if two equal booleans are compared" do
        conditional_statement = ConditionalStatement.new("false is false")
        conditional_statement.true?.should be_true
      end


      it "should be false if two unequal booleans are compared" do
        conditional_statement = ConditionalStatement.new("true is false")
        conditional_statement.true?.should be_false
      end


      it "should be true if nil is compared to nil" do
        conditional_statement = ConditionalStatement.new("nil is nothing")
        conditional_statement.true?.should be_true
      end


      it "should be false if a number and a boolean are compared" do
        conditional_statement = ConditionalStatement.new("1 == true")
        conditional_statement.true?.should be_false
      end


      it "should be false if a number and a string are compared" do
        conditional_statement = ConditionalStatement.new("1 == '1'")
        conditional_statement.true?.should be_false
      end


      it "should be false if a number and nil are compared" do
        conditional_statement = ConditionalStatement.new("1 == null")
        conditional_statement.true?.should be_false
      end


      it "should be false if a number and an array are compared" do
        conditional_statement = ConditionalStatement.new("1 == [1]")
        conditional_statement.true?.should be_false
      end


      it "should be false if a string and an array are compared" do
        conditional_statement = ConditionalStatement.new("'1' == [1]")
        conditional_statement.true?.should be_false
      end


      it "should be false if a nil and an array are compared" do
        conditional_statement = ConditionalStatement.new("nil == []")
        conditional_statement.true?.should be_false
      end


      it "should be false if a boolean and an array are compared" do
        conditional_statement = ConditionalStatement.new("false == [false]")
        conditional_statement.true?.should be_false
      end


      it "should be false if a nil and an array are compared" do
        conditional_statement = ConditionalStatement.new("nil == []")
        conditional_statement.true?.should be_false
      end


      it "should be false if a regexp and an array are compared" do
        conditional_statement = ConditionalStatement.new("/abc/ == ['abc']")
        conditional_statement.true?.should be_false
      end


      it "should be false if a boolean and a string are compared" do
        conditional_statement = ConditionalStatement.new("false == 'false'")
        conditional_statement.true?.should be_false
      end


      it "should be false if a nil and a string are compared" do
        conditional_statement = ConditionalStatement.new("nil == ''")
        conditional_statement.true?.should be_false
      end


      it "should be false if a regexp and a string are compared" do
        conditional_statement = ConditionalStatement.new("/abc/ == 'abc'")
        conditional_statement.true?.should be_false
      end

    end




    describe "when using \"=~\"" do

      it "should be true if a regexp and a matching string are compared" do
        conditional_statement = ConditionalStatement.new("/colou?r/ =~ 'my color'")
        conditional_statement.true?.should be_true
      end


      it "should be true if a string and a matching regexp are compared" do
        conditional_statement = ConditionalStatement.new("'my color' matches /colou?r/")
        conditional_statement.true?.should be_true
      end


      it "should be true if a regexp and a non-matching string are compared" do
        conditional_statement = ConditionalStatement.new("/colou?r/ =~ 'is red'")
        conditional_statement.true?.should be_false
      end


      it "should raise the proper error if valid types aren't compared" do
        lambda {
          conditional_statement = ConditionalStatement.new("'weird' matches '15'")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "'weird' matches '15'" (these elements cannot be compared using matches)})
      end


      it "should raise the proper error if a regexp and number are compared" do
        lambda {
          conditional_statement = ConditionalStatement.new("/colou?r/ matches 15")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "/colou?r/ matches 15" (these elements cannot be compared using matches)})
      end


      it "should be false if a regexp and nil are compared (odd)" do
        conditional_statement = ConditionalStatement.new("'string' =~ 15")
        conditional_statement.true?.should be_false
      end


      it "should be false if a string and a number are compared (really odd)" do
        conditional_statement = ConditionalStatement.new("'string' =~ 15")
        conditional_statement.true?.should be_false
      end

    end




    describe "when using \"gt\"" do

      it "should be true if a larger number is compared against a smaller" do
        conditional_statement = ConditionalStatement.new("10 gt 5")
        conditional_statement.true?.should be_true
      end


      it "should be false if a smaller number is compared against a larger" do
        conditional_statement = ConditionalStatement.new("5 gt 10")
        conditional_statement.true?.should be_false
      end


      it "should be false if a number is compared against an equal number" do
        conditional_statement = ConditionalStatement.new("5 gt 5")
        conditional_statement.true?.should be_false
      end


      it "should raise the proper error if valid types aren't compared" do
        lambda {
          conditional_statement = ConditionalStatement.new("5 gt 'trees'")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "5 gt 'trees'" (these elements cannot be compared using greater-than)})
      end


    end




    describe "when using \"gte\"" do

      it "should be true if a larger number is compared against a smaller" do
        conditional_statement = ConditionalStatement.new("10 gte 5")
        conditional_statement.true?.should be_true
      end


      it "should be false if a smaller number is compared against a larger" do
        conditional_statement = ConditionalStatement.new("5 gte 10")
        conditional_statement.true?.should be_false
      end


      it "should be true if a number is compared against an equal number" do
        conditional_statement = ConditionalStatement.new("5 gte 5")
        conditional_statement.true?.should be_true
      end


      it "should raise the proper error if valid types aren't compared" do
        lambda {
        conditional_statement = ConditionalStatement.new("5 gte 'trees'")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "5 gte 'trees'" (these elements cannot be compared using greater-than-or-equal)})
      end

    end




    describe "when using \"lt\"" do

      it "should be true if a larger number is compared against a smaller" do
        conditional_statement = ConditionalStatement.new("5 lt 10")
        conditional_statement.true?.should be_true
      end


      it "should be false if a smaller number is compared against a larger" do
        conditional_statement = ConditionalStatement.new("10 lt 5")
        conditional_statement.true?.should be_false
      end


      it "should be false if a number is compared against an equal number" do
        conditional_statement = ConditionalStatement.new("5 lt 5")
        conditional_statement.true?.should be_false
      end


      it "should raise the proper error if valid types aren't compared" do
        lambda {
          conditional_statement = ConditionalStatement.new("5 lt 'trees'")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "5 lt 'trees'" (these elements cannot be compared using less-than)})
      end

    end




    describe "when using \"lte\"" do

      it "should be true if a larger number is compared against a smaller" do
        conditional_statement = ConditionalStatement.new("5 lte 10")
        conditional_statement.true?.should be_true
      end


      it "should be false if a smaller number is compared against a larger" do
        conditional_statement = ConditionalStatement.new("10 lte 5")
        conditional_statement.true?.should be_false
      end


      it "should be true if a number is compared against an equal number" do
        conditional_statement = ConditionalStatement.new("5 lte 5")
        conditional_statement.true?.should be_true
      end


      it "should raise the proper error if valid types aren't compared" do
        lambda {
          conditional_statement = ConditionalStatement.new("5 lte 'trees'")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "5 lte 'trees'" (these elements cannot be compared using less-than-or-equal)})
      end

    end



    describe "when using \"exists?\"" do

      it "should be true if the primary element is not nil" do
        conditional_statement = ConditionalStatement.new("5 exists?")
        conditional_statement.true?.should be_true
      end


      it "should be false if the primary element is nil" do
        conditional_statement = ConditionalStatement.new("nil exists?")
        conditional_statement.true?.should be_false
      end


      it "should raise the proper error if a comparison element is provided" do
        lambda {
          conditional_statement = ConditionalStatement.new("10 exists? 'tree'")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "10 exists? 'tree'" (the exists? comparison cannot be followed by a comparison element)})
      end

    end




    describe "when using \"includes\"" do

      it "should be true if all of the comparison element items are in the primary element" do
        conditional_statement = ConditionalStatement.new("[3, 4, 2, 1] includes [1, 3, 2]")
        conditional_statement.true?.should be_true
      end


      it "should be false if any of the comparison element items are not in the primary element" do
        conditional_statement = ConditionalStatement.new("[1, 2, 3] includes [3, 'house']")
        conditional_statement.true?.should be_false
      end


      it "should be true if any of the comparison element is an empty array" do
        conditional_statement = ConditionalStatement.new("[1, 2, 3] includes []")
        conditional_statement.true?.should be_true
      end


      it "should raise the proper error if valid types aren't compared" do
        lambda {
          conditional_statement = ConditionalStatement.new("5 includes 'trees'")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "5 includes 'trees'" (only lists can be compared using 'includes')})
      end

    end




    describe "when using \"includes-any\"" do

      it "should be true if all of the comparison element items are in the primary element" do
        conditional_statement = ConditionalStatement.new("[3, 4, 2, 1] includes-any [1, 3, 2]")
        conditional_statement.true?.should be_true
      end


      it "should be true if any of the comparison element items are not in the primary element" do
        conditional_statement = ConditionalStatement.new("[1, 2, 3] includes-any [3, 'house']")
        conditional_statement.true?.should be_true
      end


      it "should be false if none of the comparison element items are not in the primary element" do
        conditional_statement = ConditionalStatement.new("[1, 2, 3] includes-any [true, 'house']")
        conditional_statement.true?.should be_false
      end


      it "should be true if any of the comparison element is an empty array" do
        conditional_statement = ConditionalStatement.new("[1, 2, 3] includes-any []")
        conditional_statement.true?.should be_true
      end


      it "should raise the proper error if valid types aren't compared" do
        lambda {
          conditional_statement = ConditionalStatement.new("5 includes-any 'trees'")
        }.should raise_error(InvalidConditionalStatement,
            %{Error in condition "5 includes-any 'trees'" (only lists can be compared using 'includes-any')})
      end

    end

  end

end