#
# Usage:
#
#  expect(fields).to include_field(name).with_value(value)
#
#  expect(fields).to include_text_field(name).with_value(value)
#

def include_field(name)
  FieldMatcher.new(name: name)
end

def include_button(name)
  FieldMatcher.new(name: name, type: :Btn)
end

def include_choice_field(name)
  FieldMatcher.new(name: name, type: :Ch)
end

def include_text_field(name)
  FieldMatcher.new(name: name, type: :Tx)
end

def include_signature(name)
  FieldMatcher.new(name: name, type: :Sig)
end

class FieldMatcher

  def initialize(name:, type: nil)
    @name = name

    @match_type = !!type
    @expected_type = type
  end

  def with_image(image)
    @match_image = true
    @expected_image = image
    self
  end

  def with_value(value)
    @match_value = true
    @expected_value = value
    self
  end

  def description
    description = "have field with name '#{@name}'"

    additions = []

    if @match_type
      additions << "type #{@expected_type}"
    end

    if @match_value
      additions << "value #{@expected_value}"
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

    field_present? &&
      image_matches? &&
      type_matches? &&
      value_matches?
  end

  private

  def field_present?
    fields = @subject.select { |x| x.name == @name }

    if fields.count == 1
      @field = fields.first
      return true
    end

    if fields.count == 0
      names = @subject.map { |x| x.name }.join("', '")
      @message = "Expected field with name '#{@name}', but only found '#{names}'."
      return false
    end

    if fields.count > 1
      @message = "Found multiple fields with name '#{@name}'!"
      return false
    end

    @message = "Failure"
    false
  end

  def image_matches?
    if @match_image
      if @field.image != @expected_image
        @message = "Expected image to equal '#{@expected_image}', but got '#{@field.image}'"
        return false
      end
    end

    true
  end

  def type_matches?
    if @match_type
      if @field.type != @expected_type
        @message = "Expected type to equal '#{@expected_type}', but got '#{@field.type}'"
        return false
      end
    end

    true
  end

  def value_matches?
    if @match_value
      if @field.value != @expected_value
        @message = "Expected value to equal '#{@expected_value}', but got '#{@field.value}'"
        return false
      end
    end

    true
  end

end
