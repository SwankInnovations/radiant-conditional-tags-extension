module ConditionalTags
  include Radiant::Taggable
  class TagError < StandardError; end

  desc %{     
    Renders the contents of the tag if the @condition@ attribute evaluates as
    TRUE. The @condition@ attribute (or simply @cond@) may include up to three
    parts:
    
    * *Primary Symbol* - A value declaration or reference to a stored value (required)
    * *Comparison Test* - Comparison operator (required pretty often)  

        * If there is only a Primary Symbol, this value may be: 'exists?', 'blank?', 
           'empty?' (or may be omitted -- implies 'exists?').
        * If there are both Primary and Comparison Symbols, may be '=', '!=', 'gt', 'lt', 'gte', 
          'lte', or 'matches'.
    * *Comparison Symbol* - Same rules as Primary Symbol (may be ommitted in 
      certain cases)
    
    Allowable Symbol Formats:
    
    * *String* - 'my unique string' or stringWithNoSpaces (note: if your string-with-spaces
      also includes a single quote, use a second single quote as an escape character.
      So, 'my unique string''s value' produces: "my unique string's value").
    * *Number* - 1234 or -123.4
    * *Boolean* - false or False or true or TRUE (boolean)
    * *Compound Symbol* - page[title] or page.part[My Page Part] refrencing stored values
    
    *Usage:*
    <pre><code><r:if condition="primarySymbol[ comparisonTest[ comparisonSymbol]]"] /></code></pre>

    *Examples:*
    <pre><code><r:if condition="page.part[My Page Part] exists">...</r:if>
       TRUE if this page has a page part named 'My Page Part'</code>

    <code><r:if cond="page.part[My Page Part]">...</r:if>
       Shorter notation - same as the previous example</code>

    <code><r:if cond="page.part[My Page Part] = ''">...</r:if>
       TRUE if a page part named 'My Page Part' exists and is blank</code>

    <code><r:if cond="page[title] != 'My Page Title'">...</r:if>
       TRUE if the page title is not 'My Page Title'</code>

    <code><r:if cond="page[url] matches /.*/about/.*/">...</r:if>
       TRUE if the page's URL matches the Regexp: '*/about/.*'</code>

    <code><r:if cond="children[count] lte 10">...</r:if>
       TRUE if the number of children is less than or equal to 10</code>

    <code><r:if cond="vars[myVarName]">...</r:if>
       TRUE if Page Title is not blank</code></pre>
  }
  tag 'if' do |tag|
    if (condition_string = tag.attr['condition']) || (condition_string = tag.attr['cond']) then
      condition = ConditionalStatement.new(condition_string)
      if condition.valid? then
        tag.expand if condition.true?
      end
    else
      raise TagError.new("'if' tag must contain 'condition' attribute")
    end
  end


#  desc %{     
#    Opposite of the @if@ tag.
#
#    *Usage:*
#    <pre><code><r:unless condition="primarySymbol[ comparisonTest[ comparisonSymbol]]"] /></code></pre>
#  }
#  tag 'unless' do |tag|
#    if (condition_string = tag.attr['condition']) || (condition_string = tag.attr['cond']) then
#      tag.expand unless parse_and_eval_condition(condition_string, tag)
#    else
#      raise TagError.new("'unless' tag must contain 'condition' attribute")
#    end
#  end

end