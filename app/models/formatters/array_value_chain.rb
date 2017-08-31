# This is a basic pass through filter for  data in elastic search.
# All formatters will specify an initialization with input initialization and an output method call.
class Formatters::ArrayValueChain

  attr_reader :input

  def initialize(input)
    @input = input
  end

  def output
    final_output = []
    if input
      input.each do |input|
        final_output << input["value_chain"]
      end
    end
    final_output
  end
end