require File.dirname(__FILE__) + '/../spec_helper'

describe ConditionalStatement do

#  scenario :pages

  it "should not permit insantiation without a paramter" do
    lambda{conditional_statement = ConditionalStatement.new}.
        should raise_error(ArgumentError)
  end


#  [ { :input_string => "'strings' =~ /(one) ring/",
#      :primary_element => "strings",
#      :comparison_type => "=~",
#      :comparison_element => %r{(one) ring},
#      :result => false },
# 
#    { :input_string => "'a string' matches /^a\\s(q|r|st)ring\\Z/",
#      :primary_element => "a string",
#      :comparison_type => "=~",
#      :comparison_element => %r{^a\s(q|r|st)ring\Z},
#      :result => true },
# 
#    { :input_string => "'string''s' match /'/",
#      :primary_element => "string's",
#      :comparison_type => "=~",
#      :comparison_element => %r{'},
#      :result => true },
# 
#    { :input_string => "'his string''s are long' matches? /string/",
#      :primary_element => "his string's are long",
#      :comparison_type => "=~",
#      :comparison_element => %r{string},
#      :result => false },
#
#    { :input_string => "/abcd/ == /abcde/",
#      :primary_element => /abcd/,
#      :comparison_type => "==",
#      :comparison_element => /abcde/,
#      :result => false },
#    
#    { :input_string => "/abcd/ equals? /abcd/",
#      :primary_element => /abcd/,
#      :comparison_type => "==",
#      :comparison_element => /abcd/,
#      :result => true },
#    
#    { :input_string => "/^(a|b)+$/ not Nothing",
#      :primary_element => /^(a|b)+$/,
#      :comparison_type => "!=",
#      :comparison_element => nil,
#      :result => true },
#    
#    { :input_string => "true == True",
#      :primary_element => true,
#      :comparison_type => "==",
#      :comparison_element => true,
#      :result => true },
#    
#    { :input_string => "false NOT true",
#      :primary_element => false,
#      :comparison_type => "!=",
#      :comparison_element => true,
#      :result => true },
#    
#    { :input_string => "TRUE <> 'relative'",
#      :primary_element => true,
#      :comparison_type => "!=",
#      :comparison_element => "relative",
#      :result => true },
#    
#    { :input_string => "False eq 'pizza'",
#      :primary_element => false,
#      :comparison_type => "==",
#      :comparison_element => 'pizza',
#      :result => false },
#    
#    { :input_string => "TRUE = False",
#      :primary_element => true,
#      :comparison_type => "==",
#      :comparison_element => false,
#      :result => false },
#    
#    { :input_string => "FALSE not_equal 55",
#      :primary_element => false,
#      :comparison_type => "!=",
#      :comparison_element => 55,
#      :result => true },
#    
#    { :input_string => "'tom' gt 'jerry'",
#      :primary_element => "tom",
#      :comparison_type => ">",
#      :comparison_element => 'jerry',
#      :result => true },
#    
#    { :input_string => "-52.78 GT 10",
#      :primary_element => -52.78,
#      :comparison_type => ">",
#      :comparison_element => 10.to_i,
#      :result => true },
#    
#    { :input_string => "0.00 equals nil",
#      :primary_element => 0.to_f,
#      :comparison_type => "==",
#      :comparison_element => nil,
#      :result => false },
#    
#    { :input_string => "15 lte 45.6",
#      :primary_element => 15,
#      :comparison_type => "<=",
#      :comparison_element => 45.6,
#      :result => true },
#    
#    { :input_string => "15 gte 45.6",
#      :primary_element => 15,
#      :comparison_type => ">=",
#      :comparison_element => 45.6,
#      :result => false },
#    
#    { :input_string => "15 lte 15.0",
#      :primary_element => 15,
#      :comparison_type => "<=",
#      :comparison_element => 15,
#      :result => true },
#    
#    { :input_string => "hello[there] != nil",
#      :primary_element => "hello[there]",
#      :comparison_type => "!=",
#      :comparison_element => nil,
#      :result => true },
#    
#    { :input_string => "its.your[lucky day] is_not nil",
#      :primary_element => "its.your[lucky day]",
#      :comparison_type => "!=",
#      :comparison_element => nil,
#      :result => true },
#
#    { :input_string => "its.your[lucky day] is_not",
#      :primary_element => "its.your[unlucky day]",
#      :comparison_type => "!=",
#      :comparison_element => nil,
#      :result => true }
#
#  ].each do |current_cond|
#    describe "when given the conditional string (#{current_cond[:input_string]})" do
#  
#      before :all do
#        @conditional_statement = ConditionalStatement.new(current_cond[:input_string])
#      end
#
#      it %{should understand the statement is valid} do
#        @conditional_statement.should be_valid
#      end
#    end
#
    
  [ { :input_string => "'string' is_blank?",
      :primary_element => "string" },
      
    { :input_string => "'a string' is_blank?",
      :primary_element => "a string" },
      
    { :input_string => "'a very long string' is_blank?",
      :primary_element => "a very long string" },
      
    { :input_string => "'a string with it''s apostrophe' blank?",
      :primary_element => "a string with it's apostrophe" },
      
    { :input_string => %{'a string with odd characters ($#^*@\%&;:,.<>[]{}=+-_`~?)' blank?},
      :primary_element => %{a string with odd characters ($#^*@\%&;:,.<>[]{}=+-_`~?)} },
      
    { :input_string => "false exists?",
      :primary_element => false },
      
    { :input_string => "False exists?",
      :primary_element => false },
      
    { :input_string => "FALSE exists?",
      :primary_element => false },
      
    { :input_string => "FaLsE exists?",
      :primary_element => false },
      
    { :input_string => "falsE exists?",
      :primary_element => false },
      
    { :input_string => "true is_empty?",
      :primary_element => true },
      
    { :input_string => "True is_empty?",
      :primary_element => true },
      
    { :input_string => "TRUE is_empty?",
      :primary_element => true },
      
    { :input_string => "TrUe is_empty?",
      :primary_element => true },
      
    { :input_string => "truE is_empty?",
      :primary_element => true },
      
    { :input_string => '/regexp/ empty?',
      :primary_element => /regexp/ },

    { :input_string => '/\A((?:[^\s])*|(cat dog))$/ empty?',
      :primary_element => /\A((?:[^\s])*|(cat dog))$/ },
    
    { :input_string => '/\b(?:\d{1,3}\.){3}\d{1,3}\b/ empty?',
      :primary_element => /\b(?:\d{1,3}\.){3}\d{1,3}\b/ },
      
    { :input_string => "10 gt 20",
      :primary_element => 10 },
      
    { :input_string => "-10 gt 20",
      :primary_element => -10 },
      
    { :input_string => "5.25 gt 20",
      :primary_element => 5.25 },

    { :input_string => "-5.25 gt 20",
      :primary_element => -5.25 },
      
    { :input_string => "+101.25 gt 20",
      :primary_element => 101.25 }
  ].each do |current_cond|
 
    describe "when the conditional string's primary element is a literal (#{current_cond[:input_string]})" do

      before :all do
        @conditional_statement = ConditionalStatement.new(current_cond[:input_string])
      end

      it %{should understand the statement is valid} do
        @conditional_statement.should be_valid
      end
      
      it %{should evaluate that element to be #{current_cond[:primary_element].inspect}} do
        @conditional_statement.primary_element.should == current_cond[:primary_element]
      end
      
    end

  end



  [ { :input_string => "10 == 5",
      :comparison_type => "==" },
      
    { :input_string => "10 = 5",
      :comparison_type => "==" },
      
    { :input_string => "10 equals? 5",
      :comparison_type => "==" },
      
    { :input_string => "10 != 5",
      :comparison_type => "!=" },
      
    { :input_string => "10 <> 5",
      :comparison_type => "!=" },
      
    { :input_string => "10 =~ 5",
      :comparison_type => "=~" },
      
    { :input_string => "10 matches? 5",
      :comparison_type => "=~" },
      
    { :input_string => "10 matches 5",
      :comparison_type => "=~" },
      
    { :input_string => "10 gt 5",
      :comparison_type => ">" },
      
    { :input_string => "10 GT 5",
      :comparison_type => ">" },
      
    { :input_string => "10 lt 5",
      :comparison_type => "<" },
      
    { :input_string => "10 LT 5",
      :comparison_type => "<" },
      
    { :input_string => "10 gte 5",
      :comparison_type => ">=" },
      
    { :input_string => "10 GTE 5",
      :comparison_type => ">=" },
      
    { :input_string => "10 lte 5",
      :comparison_type => "<=" },
      
    { :input_string => "10 LTE 5",
      :comparison_type => "<=" },
      
    { :input_string => "'test' blank?",
      :comparison_type => "blank?" },
      
    { :input_string => "'test' is_blank?",
      :comparison_type => "blank?" },
      
    { :input_string => "'test' empty?",
      :comparison_type => "empty?" },
      
    { :input_string => "'test' is_empty?",
      :comparison_type => "empty?" },
      
    { :input_string => "'test' exists?",
      :comparison_type => "exists?" }
      
  ].each do |current_cond|

    describe "when the conditional string's comparison type is valid (#{current_cond[:input_string]})" do

      before :all do
        @conditional_statement = ConditionalStatement.new(current_cond[:input_string])
      end

      it %{should understand the statement is valid} do
        @conditional_statement.should be_valid
      end
      
      it %{should evaluate that comparison type to be "#{current_cond[:comparison_type]}"} do
        @conditional_statement.comparison_type.should == current_cond[:comparison_type]
      end
      
    end

  end
#
#
#      
#    describe "when the conditional string's comparison element is a literal (#{current_cond[:input_string]})" do
#      it %{should find that element to be #{current_cond[:comparison_element].inspect}} do
#        ConditionalStatement.new(current_cond[:input_string]).comparison_element.should ==
#            current_cond[:comparison_element]
#      end
#    end
#    
#  end
    


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
