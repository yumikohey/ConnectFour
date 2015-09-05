class Game
	PLAYERS = [:first, :second]

	attr_reader :gameboard, :cols, :rows, :connect_number, :current_player, :winner

	def initialize
		@current_player = PLAYERS.first
		@winner = nil
		game_intro
		@gameboard = Board.new(@cols,@rows)
		rounds
	end

	def game_intro
		puts "Welcome to Connect Four"
		define_columns
		define_rows
		define_connect_number
		players_info
	end

	def define_columns
		puts "How many columns you would like to have?"
		@cols = STDIN.gets.chomp.to_i
	end

	def define_rows
		puts "How many rows you would like to have?"
		@rows = STDIN.gets.chomp.to_i
	end

	def define_connect_number
		puts "How many 'pieces' connected will win?"
		@connect_number = STDIN.gets.chomp.to_i
		while (@connect_number > @rows - @connect_number)
			puts "Please input a number, which is smaller than #{@rows} - (#{@connect_number})"
			@connect_number = STDIN.gets.chomp.to_i
		end
	end

	def players_info
		puts "First player will be represented 'o'."
		puts "Second player will be represented by 'x'."
	end

	def rounds
		loop do
			play_game
			break unless play_again?
		end
	end

	def play_game
		loop do
			@gameboard.update_board
			break if game_over?
			@gameboard.player_turn(@current_player)
			switch_player
		end
	end

	def switch_player
		# drop the current_player from PLAYERS to switch player
		@current_player = PLAYERS.reject{ |player| player == @current_player }.first
	end

	def game_over?
		return true if horizontal_line? 
	    return true if vertical_line?
		return true if diagonal_sw_ne?
		return true if diagonal_nw_se?
	end

	def horizontal_line?
		horizon = false
		0.upto(@rows-1) do |row|
			0.upto(@cols-@connect_number+1) do |col|
				if (@gameboard.board[row][col] != " ")
					count = 0
					0.upto(@connect_number-1) do |number|
						# check each row by indexing up column
						count+= 1 if @gameboard.board[row][col+number] == @gameboard.board[row][col]
					end
					horizon = true if count == @connect_number
				end
			end
		end
		consecutive_pieces(:horizon) if horizon
		return horizon
	end

	def vertical_line?
		vertical = false
		row = @rows - 1
		while row > @connect_number do 
			0.upto(@cols-1) do |col|
				if (@gameboard.board[row][col] != " ")
					count = 0
					0.upto(@connect_number-1) do |number|
						# check row from the top, indexing down row while column stays the same
						count+= 1 if @gameboard.board[row-number][col] == @gameboard.board[row][col]
					end
					vertical = true if count == @connect_number
				end
			end
			row -= 1
		end
		consecutive_pieces(:vertical) if vertical
		return vertical
	end

	def diagonal_sw_ne?
		diagonal = false
		row = @rows - 1
		while row > @connect_number do 
			0.upto(@cols-@connect_number+1) do |col|
				if (@gameboard.board[row][col] != " ")
					count = 0
					0.upto(@connect_number-1) do |number|
						# check row from the top, indexing down row while column indexing up
						count+= 1 if @gameboard.board[row-number][col+number] == @gameboard.board[row][col]
					end
					diagonal = true if count == @connect_number
				end
			end
			row -= 1
		end
		consecutive_pieces(:sw_ne) if diagonal
		return diagonal
	end

	def diagonal_nw_se?
		diagonal = false
		row = 0
		while row < @connect_number do 
			0.upto(@cols-@connect_number+1) do |col|
				if (@gameboard.board[row][col] != " ")
					count = 0
					0.upto(@connect_number-1) do |number|
						# check row from the bottom, both row and column indexing up
						count+= 1 if @gameboard.board[row+number][col+number] == @gameboard.board[row][col]
					end
					diagonal = true if count == @connect_number
				end
			end
			row += 1
		end
		consecutive_pieces(:nw_se) if diagonal
		return diagonal
	end

	def consecutive_pieces(type)
		@winner = switch_player
		puts "The #{@winner} player is #{type} winner" 
	end

	def play_again?
		puts "do you want to play again? (y or n)"
		user_input = gets.chomp
		if user_input == "y"
			@gameboard = Board.new(@cols,@rows)
			return true
		end
	end

end