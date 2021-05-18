class State
	def initialize(label, rules, dot_idx, start_idx, end_idx, idx, made_from, producer)
		@label = label
        @rules = rules
        @dot_idx = dot_idx
        @start_idx = start_idx
        @end_idx = end_idx
        @idx = idx
        @made_from = made_from
        @producer = producer
	end

	attr_accessor :label, :rules, :dot_idx, :start_idx, :end_idx, :idx, :made_from, :producer

	def nextSymbol
		return @rules[@dot_idx]
	end

	def complete
		return @rules.length == @dot_idx
	end

	def ==(other)
        return (@label == other.label &&
                @rules == other.rules &&
                @dot_idx == other.dot_idx &&
                @start_idx == other.start_idx &&
				@end_idx == other.end_idx)
	end

	def to_s()
		rule_string = ''
		
		@rules.each_with_index do |rule, i|
            if i == @dot_idx
				rule_string += '.'
			end
			rule_string << rule << ''
		end
        if @dot_idx == @rules.length
			rule_string << '.'
		end
		return "S#{@idx} | #{@label}->#{rule_string} | [#{@start_idx}, #{@end_idx}] #{@made_from} #{@producer}"
	end
end