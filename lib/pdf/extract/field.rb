module PDF
  module Extract
    class Field
      BOM_BYTES = [0xFF, 0xFE].freeze

      attr_reader :data, :reference_resoler

      def initialize(data, reference_resoler)
        @data = data
        @reference_resoler = reference_resoler
      end

      # PDF Reference 6th Edition, Version 1.7, November 2006 page 675
      # The partial field name
      def name
        data[:T]
      end

      # PDF Reference 6th Edition, Version 1.7, November 2006 page 675
      # The type of field that this dictionary describes.
      def type
        data[:FT]
      end

      # PDF Reference 6th Edition, Version 1.7, November 2006 page 676
      # The field’s value, whose format varies depending on the field type.
      def value
        string_value = data[:V]
        if string_value.encoding == Encoding::ASCII_8BIT && string_value.bytes[0..1].all? { |b| BOM_BYTES.include?(b) }
          # It's a UTF-16 encoded string, but for some reason we think it's encoded as ASCII, correct the encoding
          string_value = string_value.encode( 'UTF-8', 'UTF-16' )
        end
        string_value
      end

      def image
        # PDF Reference 6th Edition, Version 1.7, November 2006 page 641
        # MK: An appearance characteristics dictionary (see Table 8.40) to be used in constructing
        # a dynamic appearance stream specifying the annotation’s visual presentation on the page.
        # The name MK for this entry is of historical significance only and has no direct meaning.
        #
        # PDF Reference 6th Edition, Version 1.7, November 2006 page 1118
        # Implementation Notes
        # If the MK entry is present in the field’s widget annotation dictionary (see Table 8.39),
        # Acrobat viewers regenerate the entire XObject appearance stream. If MK is not present,
        # the contents of the stream outside /Tx BMC ... EMC are preserved.
        mk = data[:MK] || {}

        mk = mk.is_a?(PDF::Reader::Reference) ? reference_resoler.lookup(mk) : mk

        # PDF Reference 6th Edition, Version 1.7, November 2006 page 642
        # I: A form XObject defining the widget annotation’s normal icon, displayed when it is not
        # interacting with the user.
        stream = reference_resoler.lookup(mk[:I])&.hash || {}

        # PDF Reference 6th Edition, Version 1.7, November 2006 page 358
        # form dictionary
        resources = reference_resoler.lookup(stream[:Resources]) || {}

        xobject = resources[:XObject] || {}

        stream = reference_resoler.lookup(xobject[:Im1])

        data = stream&.data

        data ? Base64.encode64(data) : nil
      end

      def as_json
        h = {
          "name" => name,
          "value" => value
        }

        image.tap { |i| h["image"] = i if i }

        h
      end
    end
  end
end
