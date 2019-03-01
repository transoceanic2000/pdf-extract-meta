module PDF
  module Extract
    class Annotation

      attr_reader :data

      def initialize(data)
        @data = data || {}
      end

      # PDF Reference 6th Edition, Version 1.7, November 2006 page 606
      # The annotation name, a text string uniquely identifying it among all the annotations on its
      # page.
      def name
        data[:NM]
      end

      # PDF Reference 6th Edition, Version 1.7, November 2006 page 606
      # Text to be displayed for the annotation or, if this type of annotation does not display
      # text, an alternate description of the annotation’s contents in human-readable form. In
      # either case, this text is useful when extracting the document’s contents in support of
      # accessibility to users with disabilities or for other purposes (see Section 10.8.2,
      # “Alternate Descriptions”). See Section 8.4.5, “Annotation Types” for more details on the
      # meaning of this entry for each annotation type.
      def contents
        data[:Contents]
      end

      def subtype
        data[:Subtype]
      end

      def as_json
        {
          "name" => name,
          "contents" => contents,
          "subtype" => subtype,
        }
      end

    end
  end
end
