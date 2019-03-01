#
# Usage:
#
#  expect(annotations).to include_annotation(name).with_contents(contents)
#
#  expect(annotations).to include_text(name).with_contents(contents)
#

def include_annotation(name)
  AnnotationMatcher.new(name: name)
end

def include_circle(name = nil)
  AnnotationMatcher.new(name: name, subtype: :Circle)
end

def include_free_text(name = nil)
  AnnotationMatcher.new(name: name, subtype: :FreeText)
end

def include_highlight(name = nil)
  AnnotationMatcher.new(name: name, subtype: :Highlight)
end

def include_line(name = nil)
  AnnotationMatcher.new(name: name, subtype: :Line)
end

def include_popup(name = nil, multiple: false)
  AnnotationMatcher.new(name: name, subtype: :Popup, multiple: multiple)
end

def include_square(name = nil)
  AnnotationMatcher.new(name: name, subtype: :Square)
end

def include_stamp(name = nil)
  AnnotationMatcher.new(name: name, subtype: :Stamp)
end

def include_strike_out(name = nil)
  AnnotationMatcher.new(name: name, subtype: :StrikeOut)
end

def include_text(name = nil)
  AnnotationMatcher.new(name: name, subtype: :Text)
end

def include_underline(name = nil)
  AnnotationMatcher.new(name: name, subtype: :Underline)
end

class AnnotationMatcher

  def initialize(name:, subtype: nil, multiple: false)
    if name
      @match_name = true
      @expected_name = name
    end

    if subtype
      @match_subtype = true
      @expected_subtype = subtype
    end

    @multiple = multiple
  end

  def with_contents(contents)
    @match_contents = true
    @expected_contents = contents
    self
  end

  def description
    description = "have annotation with "

    additions = []

    if @match_name
      additions << "name '#{@expected_name}'"
    end

    if @match_contents
      additions << "contents '#{@expected_contents}'"
    end

    if @match_subtype
      additions << "subtype '#{@expected_subtype}'"
    end

    if additions.any?
      description += "with #{additions[0..-2].join(', ')}"

      if additions.length > 1
        description += " and #{additions.last}."
      end
    end

    description
  end

  def failure_message
    @message
  end

  def matches?(subject)
    @subject = subject

    annotation_present? &&
      contents_matches? &&
      subtype_matches?
  end

  private

  def annotation_present?
    if @expected_name
      find_annotations(:name, @expected_name)
    elsif @expected_subtype
      find_annotations(:subtype, @expected_subtype)
    end
  end

  def find_annotations(key, value)
    annotations = @subject.select { |x| x.send(key) == value }

    if annotations.count == 1
      @annotation = annotations.first
      return true
    end

    if @multiple && annotations.count > 1
      @annotations = annotations
      return true
    end

    if annotations.count == 0
      values = @subject.map { |x| x.send(key) }.join("', '")
      @message = "Expected annotation with #{key} '#{value}', but only found '#{values}'."
      return false
    end

    if !@multiple && annotations.count > 1
      @message = "Found multiple annotations with #{key} '#{value}'!"
      return false
    end

    @message = "Failure"
    false
  end

  def contents_matches?
    if @match_contents
      if @multiple
        index = 0
        @annotations.each do |annotation|
          if annotation.contents != @expected_contents
            @message = "Expected contents to equal '#{@expected_contents}', but got '#{@annotation.contents}' (index #{index}}"
            return false
          end
          index = index + 1
        end
      else
        if @annotation.contents != @expected_contents
          @message = "Expected contents to equal '#{@expected_contents}', but got '#{@annotation.contents}'"
          return false
        end
      end
    end

    true
  end

  def subtype_matches?
    if @match_subtype
      if @multiple
        index = 0
        @annotations.each do |annotation|
          if annotation.subtype != @expected_subtype
            @message = "Expected subtype to equal '#{@expected_subtype}', but got '#{@annotation.subtype}' (index #{index}}"
            return false
          end
          index = index + 1
        end
      else
        if @annotation.subtype != @expected_subtype
          @message = "Expected subtype to equal '#{@expected_subtype}', but got '#{@annotation.subtype}'"
          return false
        end
      end
    end

    true
  end

end
