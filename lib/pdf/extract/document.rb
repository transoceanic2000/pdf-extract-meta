module PDF
  module Extract
    class Document

      PAGE_ANNOTATIONS_KEY = :Annots

      attr_reader :document

      def initialize(path:)
        @document = ::PDF::Reader.new(path)
      end

      def annotations
        reference_resoler.lookup(annotation_references).map { |h|
          Annotation.new(h)
        }
      end

      def fields
        reference_resoler.lookup(field_references).map { |h|
          Field.new(h, reference_resoler)
        }
      end

      private

      def annotations_for_page(page)
        page.attributes[PAGE_ANNOTATIONS_KEY]
      end

      def annotation_references
        pages.map { |page| annotations_for_page(page) }.flatten.compact
      end

      def field_references
        # PDF Reference 6th Edition, Version 1.7, November 2006 page 672
        # Interactive Form Dictionary
        ifd = objects.values.select { |x| x.respond_to?(:keys) && x.keys.include?(:Fields) }.first || {}
        refs = ifd[:Fields]
        refs || []
      end

      def objects
        document.objects || {}
      end

      def pages
        document.pages
      end

      def reference_resoler
        ReferenceResolver.new(document: document)
      end

    end
  end
end
