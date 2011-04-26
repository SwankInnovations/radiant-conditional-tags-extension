module ConditionalTags

  class InvalidConditionalStatement < StandardError; end

  module PageTagsExt

    include Radiant::Taggable
    class TagError < StandardError; end

    desc %{
      Renders the contents of the tag if the @cond@ attribute evaluates as
      TRUE. The @cond@ attribute must be a conditional statement made up of:

      * *Primary Element* - This is one of two possible elements in the @cond@ and
        is always required.
      * *Comparison Type* - This tells how the *Primary Element* and *Comparison
        Elements* should be compared with each other.  It is always required.
      * *Comparison Element* - This element defines what to compare agains and is
        either required or must be omitted depending on the *Comparison Type*.

      *Usage:*
      <pre><code><r:if condition="PrimaryElement ComparisonType[ ComparisonElement]"] /></code></pre>

      *Kinds of Elements:*
      * *Literal Elements* - These are just what they say. They can be *text*
        (like 'some text'), *number* (like 12 or -123.4), *T/F* (like true),
        *nothing* (like nothing, nil, or null), *regular expression* (like
        /colou?r/), or a *list* (like ['some text', 'another bit'])
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

      <code><r:if cond="part-names includes ['body', 'another part']">...</r:if>
         TRUE if both "body" and "another part" are content tabs on the page</code>

      <code><r:if cond="part-names includes ['body', 'another part']">...</r:if>
         TRUE if either "body" or "another part" are content tabs on the page</code>

      <code><r:if cond="url matches /products/">...</r:if>
         TRUE if the page url includes the text "products"</code>

      <code><r:if cond="children.count lte 10">...</r:if>
         TRUE if the number of children is less than or equal to 10</code>

    }
    tag 'if' do |tag|
      if (condition_string = tag.attr['condition']) || (condition_string = tag.attr['cond']) then
        begin
          tag.expand if ConditionalStatement.new(condition_string, tag).true?
        rescue InvalidConditionalStatement
          raise TagError.new("'if' tag error: #{$!}")
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
          raise TagError.new("'unless' tag error: #{$!}")
        end
      else
        raise TagError.new("'unless' tag must contain 'condition' attribute")
      end
    end


    desc %{
      Renders the value of an element. The @value_for@ attribute specifies
      which element the same way that the @if@ and @unless@ tags work (i.e.
      @value_for="content[body]"@ outputs the content of the body page part).
      
      Adding the @if attribute will render the element iff the condition is true.
      The condition syntax is the same as for the @if tag. The @if attribute is 
      optional.

      Adding the @text atribute will allow it to render simple text. This, of course,
      is only useful when paired with the @if attribute.
      
      *Usage:*
      <pre><code><r:puts value_for="varName|*all*" /></code></pre>
    }
    tag 'puts' do |tag|
        if custom_element_text = tag.attr['value_for'] or text = tag.attr['text']
        begin

          if custom_element_text
            value = CustomElement.new(custom_element_text, tag).value
            if tag.attr['more'] == 'true'
            value = value.to_s + ":" + value.class.to_s
            end
          end
          
          if text
            value = text
          end

          if if_string = tag.attr['if']
            value if ConditionalStatement.new(if_string, tag).true?
          else
            value  
          end
        rescue InvalidConditionalStatement
          raise TagError.new("'puts' tag error: #{$!}")
        end
      else
        raise TagError.new("`puts' tag must contain a 'value_for' or 'text' attribute")
      end
    end

  end
end