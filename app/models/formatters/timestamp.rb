class Formatters::Timestamp

	attr_reader :input

	def initialize(input)
		@input = input
	end

	def output
		@input
	end
end