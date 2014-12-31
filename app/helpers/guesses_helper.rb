module GuessesHelper
	def answer_ok?(value)
		return 'o' if value.to_i == 10
		return 'x' if value.to_i == 0
	end

	def answer_flag(value)
		return 'glyphicon-ok-circle ' if value.to_i == 10
		return 'glyphicon-remove-circle ' if value.to_i == 0
	end

end
