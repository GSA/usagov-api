# This is a basic pass through filter for  data in elastic search.
# All formatters will specify an initialization with input initialization and an output method call.
class Formatters::PassThru

	attr_reader :input

	def initialize(input)
		@input = input
	end

	def output
		input
	end
end