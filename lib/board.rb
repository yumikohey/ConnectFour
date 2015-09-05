class Board
	attr_reader :board, :cols, :rows

	def initialize(cols, rows)
		@cols = cols 
		@rows = rows
		draw_board
	end

	def draw_board
		@board = []
		@rows.times do
			blank_row = []
			@cols.times { blank_row << " "}
			@board << blank_row
		end
	end

	def empty_board?
		empty = true
		(@rows-1).downto(0) do |row|
			(@cols-1).downto(0) do |col|
				if @board[row][col] != " "
					empty = false
				end
			end
		end
		return empty
	end

	def update_board
		p (1..@cols).to_a
		@board.each do |row|
			p row
		end
	end

	def player_turn(current_player)
		symbol = "x"
		symbol = "o" if current_player == :first

		puts "#{current_player} player: Select the column to place your piece: "
		player_input = STDIN.gets.chomp.to_i - 1
		row = @rows - 1
		while @board[row][player_input] != " "
			row -= 1 if row != 0
		end
		@board[row][player_input] = symbol
		@board.each do |update_row|
			p update_row
		end
	end
end