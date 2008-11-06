module ConditionalTags
  module Evaluatable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def evaluator(identifier, index_setting = nil, &block)
        identifier = identifier.to_s
        if index_setting == :no_index_allowed
          updated_block = lambda do |tag, element|
            if element.has_key? :index
              raise InvalidCustomElement,
                  "#{identifier} element cannot include an index"
            end
            block.call(tag, element)
          end
        elsif index_setting == :index_required
          updated_block = lambda do |tag, element|
            unless element.has_key? :index
              raise InvalidCustomElement,
                  "#{identifier} element requires an index"
            end
            block.call(tag, element)
          end
        else
          updated_block = block
        end
        ConditionalTags::CustomElement.register_evaluator(identifier, updated_block)
      end
    end

  end
end