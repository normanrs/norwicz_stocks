class Topping
	attr_reader :id,
							:type

	def initialize(data)
		@id = data[:id].to_i
		@type = data[:type]
	end

end
