module Emcee
  module Processors
    # StylesheetProcessor scans a document for external stylesheet references and
    # inlines them into the current document.
    class StylesheetProcessor
      def initialize(resolver)
        @resolver = resolver
      end

      def process(doc)
        inline_styles(doc)
        doc
      end

      private

      def inline_styles(doc)
        doc.style_references.each do |node|
          path = @resolver.absolute_path(node.path)
          return unless @resolver.should_inline?(path)
          content = @resolver.evaluate(path)
          new_path = path.sub(@resolver.context.root_path, '/assets')
          node.parser_node.attributes['href'].value = new_path
        end
      end
    end
  end
end
