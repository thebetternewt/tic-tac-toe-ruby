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
    selected_square.piece == blank_square_string ? true : false
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
      puts "\nSorry, invalid move! There is already a piece in that square.\n"
      return false
    end
  end

end

class Player
  attr_reader :name, :symbol
  def initialize
    @name = get_player_name
    @symbol = choose_symbol
  end

  private

  def get_player_name
    gets.chomp
  end

  def choose_symbol
    print "\nHi, #{name}! Please enter the symbol would you like to use. >> "
    gets.chomp
  end

  def validate_move_input?(input)
    input =~ /[A-C][1-3]/ ? true : false
  end

  public

  def take_turn
    print "\n#{name}, please enter your next move. >> "
    location = gets.upcase.chomp
    while !validate_move_input?(location)
      puts "\nSorry, that is an invalid move. Please choose a valid row-column"
      print "combination (e.g. A1) >> "
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

print "\nPlayer 1, please type your name. >> "
player1 = Player.new()
puts "\n#{player1.name}, you've chosen to use #{player1.symbol}."

print "\nPlayer 2, please type your name. >> "
player2 = Player.new()
puts "\n#{player2.name}, you've chosen to use #{player2.symbol}."

current_player ||= player1

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
