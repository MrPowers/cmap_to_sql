module Cmap; class ColumnParser

  DETECT_KEY_REGEX = /_?[:]_?/

  def initialize(original_name)
    @original_name = original_name
  end

  def column
    parse_input(:first, @original_name)
  end

  def type
    parse_input(:last, "int2")
  end

  private

  def parse_input(position_key, default_value)
    key_detected = DETECT_KEY_REGEX.match(@original_name)
    return default_value unless key_detected

    sections = @original_name.split(DETECT_KEY_REGEX)
    if sections.count == 2
      sections.send(position_key)
    else
      default_value
    end
  end

end; end
