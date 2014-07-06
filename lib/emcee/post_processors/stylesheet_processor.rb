module Emcee
  module PostProcessors
    # StylesheetProcessor scans a document for external stylesheet references and
    # inlines them into the current document.
    class StylesheetProcessor
      def initialize(context)
        @context = context
        @directory = File.dirname(context.pathname)
      end

      def process(doc)
        inline_styles(doc)
        doc
      end

      private

      def inline_styles(doc)
        doc.css("link[rel='stylesheet']").each do |node|
          path = absolute_path(node.attribute("href"))
          content = @context.evaluate(path)
          style = create_style(doc, content)
          node.replace(style)
        end
      end

      def absolute_path(path)
        File.absolute_path(path, @directory)
      end

      def create_style(doc, content)
        node = Nokogiri::XML::Node.new("style", doc)
        node.content = content
        node
      end
    end
  end
end
