module ConditionalTags
  include Radiant::Taggable
  class TagError < StandardError; end
  class InvalidConditionalStatement < StandardError; end

  desc %{
    Renders the contents of the tag if the @cond@ attribute evaluates as
    TRUE. The @cond@ attribute must be a valid conditional statement made up of:

    * *Primary Element* - This is one of two possible elements in the @cond and
      is always required.
    * *Comparison Type* - This tells how the *Primary Element* and *Comparison
      Elements* should be compared with each other.  It is always required.
    * *Comparison Element* - This element defines what to compare agains and is
      either required or must be omitted depending on the *Comparison Type*.

    *Usage:*
    <pre><code><r:if condition="PrimaryElement ComparisonType[ ComparisonElement]"] /></code></pre>

    *Kinds of Elements:*
    * *Text* - 'My Text' Text must be surrounded by apostrophes. If you need
      to use the apostrophe character in the text, use it twice to "escape" it
      (i.e. 'Jim''s Text' produces: "Jim's Text").
      So, 'my unique string''s value' produces: "my unique string's value").
    * *Number* - 1234 or -123.4
    * *True/False* - false or False or true or TRUE (boolean).
    * *Nothing* - nothing, null, or nil
    * *RegExp* - /regexp/  Regular expressions are fancy tools to perform
      matching against strings. You'd use these along with the "matches"
      *Comparison Type*.
    * *List* - ['some text', 'more text'] a group of Text, Number, True/False,
      and/or Nothing elements.
    * *Custom Element* - Like: title, content['my page part'], or children.count,
      These elements refer to values about your site or its content.

    *Kinds of Comparisons*
    * *equals* (also *is*, *=*, or *==) - Checks equality.
    * *matches* (also *=~*) - Checks whether a regexp matches a string
    * *gt* - Checks whether Primary Element is greater than the Comparison Element
    * *lt* - Checks whether Primary Element is less than the Comparison Element
    * *gte* - Checks whether Primary Element is greater than or equal to the Comparison Element
    * *lte* - Checks whether Primary Element is less than or equal to the Comparison Element
    * *includes* (also *includes-all*) - Checks whether all items in Comparison Element are found in Primary Element
    * *includes-any* - Checks whether any of the items in Comparison Element are are found in Primary Element

    *Examples:*
    <code><r:if cond="title is 'My Page Title'">...</r:if>
       TRUE if the page title is "My Page Title"</code>

    <pre><code><r:if condition="content['some part'] exists?">...</r:if>
       TRUE if this page has a content tab named "some part"</code>

    <code><r:if cond="content includes ['body', 'another part']">...</r:if>
       TRUE if both "body" and "another part" are content tabs on the page</code>

    <code><r:if cond="content includes ['body', 'another part']">...</r:if>
       TRUE if either "body" or "another part" are content tabs on the page</code>

    <code><r:if cond="url matches /products/">...</r:if>
       TRUE if the page url includes the text "products"</code>

    <code><r:if cond="page[url] matches /.*/about/.*/">...</r:if>
       TRUE if the page's URL matches the Regexp: '*/about/.*'</code>

    <code><r:if cond="children.count lte 10">...</r:if>
       TRUE if the number of children is less than or equal to 10</code>

  }
  tag 'if' do |tag|
    if (condition_string = tag.attr['condition']) || (condition_string = tag.attr['cond']) then
      begin
        tag.expand if ConditionalStatement.new(condition_string, tag).true?
      rescue InvalidConditionalStatement
        raise TagError.new("'if' tag error: #{$1}")
      end
    else
      raise TagError.new("'if' tag must contain 'condition' attribute")
    end
  end


  desc %{
    Opposite of the @if@ tag (see @if@ tag for details on usage)

    *Usage:*
    <pre><code><r:unless condition="primarySymbol[ comparisonTest[ comparisonSymbol]]"] /></code></pre>
  }
  tag 'unless' do |tag|
    if (condition_string = tag.attr['condition']) || (condition_string = tag.attr['cond']) then
      begin
        tag.expand unless ConditionalStatement.new(condition_string, tag).true?
      rescue InvalidConditionalStatement
        raise TagError.new("'unless' tag error: #{$1}")
      end
    else
      raise TagError.new("'unless' tag must contain 'condition' attribute")
    end
  end

end