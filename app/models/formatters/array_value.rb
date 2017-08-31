# This is a basic pass through filter for  data in elastic search.
# All formatters will specify an initialization with input initialization and an output method call.
class Formatters::ArrayValue

  attr_reader :input

  def initialize(input)
    @input = input
  end

  def output
    final_output = []
    if input
      input.each do |input|
        if input["value"]
          final_output << input["value"] 
        elsif
          final_output << input
        end
      end
    end
    final_output
  end
end