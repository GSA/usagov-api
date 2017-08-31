class Formatters::UrlLocation
	attr_reader :input

	def initialize(input)
		@input = input
	end

	def output
		["https://#{ENV['CMP_USAGOV_HOST']}/narrative_content.html?content_id=#{@input}"]
	end
end
