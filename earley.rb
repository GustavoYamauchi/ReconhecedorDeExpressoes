require_relative "./state.rb"

class Earley
	def initialize(input, grammar, terminals)
		@chart = Array.new(input.length + 1){[]}
        @current_id = 0
        @input = input
        @grammar = grammar
		@terminals = terminals
		parse
	end

	attr_accessor :chart, :current_id, :input, :grammar, :terminals

    def get_new_id
        @current_id += 1
        return @current_id - 1
	end

    def is_terminal(tag)
        return @terminals.include? tag
	end

    def enqueue(state, chart_entry)
        if !@chart[chart_entry].include? state
            @chart[chart_entry].push(state)
        else
            @current_id -= 1
		end
	end

	def predictor(state)
        @grammar[state.nextSymbol].each do |production|
            enqueue(State.new(state.nextSymbol, production, 0, state.end_idx, state.end_idx, get_new_id, [], 'predictor'), state.end_idx)
		end
	end

    def scanner(state)
        if @grammar[state.nextSymbol].include? @input[state.end_idx]
			enqueue(State.new(state.nextSymbol, [@input[state.end_idx]], 1, state.end_idx, state.end_idx + 1, get_new_id, [], 'scanner'), state.end_idx + 1)
		end
	end

    def completer(state)
        @chart[state.start_idx].each do |s|
            if !s.complete && s.nextSymbol == state.label && s.end_idx == state.start_idx && s.label != 'Q'
                enqueue(State.new(s.label, s.rules, s.dot_idx + 1, s.start_idx, state.end_idx, get_new_id, s.made_from + [state.idx], 'completer'), state.end_idx)
			end
		end
	end

	def is_successfully_parsed()
		is_successfully = false
		lastChart = @chart.pop()

		lastChart.each do |s|
			if s.label == 'S' && s.start_idx == 0 && s.complete
				is_successfully = true
			end
		end

		return is_successfully
	end

    def parse()
        enqueue(State.new('Q', ['S'], 0, 0, 0, get_new_id, [], 'initial state - lets bora'), 0)
        
        for i in 0...@input.length + 1
			@chart[i].each do |state|
				if !state.complete
					if is_terminal(state.nextSymbol)
						scanner(state)
					else
						predictor(state)
					end
                else
					completer(state)
				end
			end
		end
	end

    def to_s()
        res = ''
		
		@chart.each_with_index do |chart, i|
            res << "\nChart[#{i}]\n"
            chart.each do |state|
				res << state.to_s << 10
			end
		end
		
		return res
	end
end