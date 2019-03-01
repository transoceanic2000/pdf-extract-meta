$:.push File.join(File.expand_path("../", __FILE__), "extract")

require "base64"
require "oj"
require "pdf-reader"

require "pdf/extract/annotation"
require "pdf/extract/document"
require "pdf/extract/field"
require "pdf/extract/reference_resolver"
require "pdf/extract/version"

module PDF
  module Extract
    class Error < StandardError; end
  end
end
