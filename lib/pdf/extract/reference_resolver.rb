module PDF
  module Extract
    class ReferenceResolver

      attr_reader :objects

      def initialize(document:)
        @objects = document.objects
      end

      def lookup(reference)
        reference.is_a?(Array) ? lookup_mutiple(reference) : lookup_single(reference)
      rescue SystemStackError
        raise PDF::Extract::Error.new("map contains infinite recursion")
      end

      private

      def lookup_mutiple(references)
        (_ = *references).map { |ref| lookup(ref) }.flatten
      end

      def lookup_single(reference)
        object = objects[reference]
        object.is_a?(Array) ? lookup_mutiple(object) : object
      end

    end
  end
end
