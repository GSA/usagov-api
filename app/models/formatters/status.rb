# This is a basic pass through filter for  data in elastic search.
# All formatters will specify an initialization with input initialization and an output method call.
class Formatters::Status

	attr_reader :input

	def initialize(input)
		@input = input
	end

	def output
		@input != 1 ? "Published" : "Archived"
	end
end