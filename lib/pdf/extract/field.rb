module PDF
  module Extract
    class Field

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
        data[:V]
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
