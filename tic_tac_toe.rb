class Array

  def same_values?
    self.uniq.size == 1
  end

end

class Board
  attr_reader :side_length, :board, :blank_square_string
  def initialize(side_length = 3)
    @side_length = side_length
    @blank_square_string = '-'

    @board = create_board
    display_board
  end

  Square = Struct.new(:piece)


  private

  def create_board
    board = []
    side_length.times { board << create_row_of_squares }
    board
  end

  def create_row_of_squares
    squares = []
    side_length.times { squares << Square.new(blank_square_string) }
    squares
  end

  def validate_player_move?(selected_square)
    if selected_square.piece == blank_square_string
      return true
    else
      puts "\nSorry, invalid move! There is already a piece in that square.\n"
      return false
    end
  end

  public

  def win?
    game_over = false
    board.each do |row| # Check rows for win.
      if row.same_values? && row.uniq[0].piece != blank_square_string
        game_over = true
      end
    end

    board.transpose.each do |column| # Check columns for win.
      if column.same_values? && column.uniq[0].piece != blank_square_string
        game_over = true
        p game_over
      end
    end

    # Check diagonals for win.
    if board.flatten.values_at(0,4,8).same_values? && board.flatten.values_at(0,4,8).uniq[0].piece != blank_square_string
      game_over = true
    end
    if board.flatten.values_at(2,4,6).same_values? && board.flatten.values_at(2,4,6).uniq[0] != blank_square_string
      game_over = true
    end

    game_over
  end

  def display_board
    print "\n"
    board.each_with_index do |row, index|
      print "#{(index - board.size).abs} "
      row.each { |square| print "#{square.piece} " }
      print "\n"
    end
    print "  A B C"
    print "\n"
  end

  def update_board(move)
    selected_square = board[move[:row]][move[:column]]
    if validate_player_move?(selected_square)
      selected_square.piece = move[:symbol]
    else
      false
    end
  end

end

class Player
  attr_reader :name, :symbol
  def initialize
    @name = get_player_name
    @symbol = choose_symbol
    greet_player
  end

  private

  def get_player_name
    print "\nPlease type your name. >> "
    gets.chomp
  end

  def choose_symbol
    print "\nPlease enter the symbol would you like to use. >> "
    gets.chomp
  end

  def greet_player
    puts "\nHi #{name}! Welcome to Tic-Tac-Toe with Ruby! You've chosen to use #{symbol} as your game piece.\n"
  end

  def validate_move_input?(input)
    if input =~ /[A-C][1-3]/
      true
    else
      puts "\nSorry, that is an invalid move. Please choose a valid row-column"
      print "combination (e.g. A1) >> "
      false
    end
  end

  public

  def take_turn
    print "\n#{name}, please enter your next move. >> "
    location = gets.upcase.chomp
    while !validate_move_input?(location)
      location = gets.upcase.chomp
    end
    move = {}
    move[:column] = location[0].ord - 65
    move[:row] = (location[1].to_i - 3).abs # TODO: Change hardcoded calculation to reference row count.
    move[:symbol] = self.symbol
    move
  end

end

my_board = Board.new()

puts
puts "Welcome to Tic-Tac-Toe in Ruby!"
puts
puts "Player 1..."
player1 = Player.new()
puts
puts "Player 2..."
player2 = Player.new()

current_player = player1

loop do
  my_board.display_board
  move = current_player.take_turn
  while !my_board.update_board(move)
    move = current_player.take_turn
  end

  break if my_board.win? == true

  if current_player == player1
    current_player = player2
  else
    current_player = player1
  end
end

my_board.display_board
puts "\nThe game is over. #{current_player.name} won!\n"
