require_relative "./earley.rb"

# Válidas
# 9^(1 * -2 + 3) - 3 / ( 6 + 3 )
# (1 + 4) * 2^4
# 7 / ( 1 - 3 )
# 9^(1 * 6 / 2 + 4)
# 2 + 4 ^ -4 / 4

# Invalidas
# ^2+4
# 9*2+
# 9++3
# ()*3
# (3+3

puts 'Digite a expressão que você quer validar'
exp = gets.chomp()

grammar = {
	# Não Terminais
	"S" => [["D", "SP", "S"], ["D"]],
	"D" => [["M", "SMI", "D"], ["M"]],
	"M" => [["R", "SMU", "M"], ["R"]],
	"R" => [["E", "SD","R"], ["E"]],
	"E" => [["P", "SE", "E"], ["N"]],
	"N" => [["SMI", "N"], ["P"]],
	"P" => [["SPO", "S", "SPC"], ["I"]],
	"I" => [["V"], ["V", "I"]],

	# Terminais
	"SP" => ["+"],
	"SMI" => ["-"],
	"SMU" => ["*"],
	"SD" => ["/"],
	"SE" => ["^"],
	"SPO" => ["("],
	"SPC" => [")"],
	"V" => ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
}

terminals = ["SP", "SMI", "SMU", "SD", "SE", "SPO", "SPC", "V"]

earley = Earley.new(exp.gsub(" ", "").split(""), grammar, terminals)

puts earley
puts
puts earley.is_successfully_parsed ? "Aceita!" : "Incorreta :("
