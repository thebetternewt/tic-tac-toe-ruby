class Board
  attr_reader :board
  def initialize(number_of_rows, number_of_columns)
    @number_of_rows = number_of_rows
    @number_of_columns = number_of_columns

    @board = create_board
    display_board
  end

  Square = Struct.new(:piece)

  private

  def create_board
    board = []
    @number_of_rows.times { board << create_row_of_squares }
    board
  end

  def create_row_of_squares
    squares = []
    @number_of_columns.times { squares << Square.new('--') }
    squares
  end

  public

  def display_board
    board.each do |row|
      row.each { |square| print "|#{square.piece}|" }
      print "\n"
    end
  end

  def update_board(location)
    board[location[1]][location[0]].piece = location[2]
    display_board
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
    puts "What symbol would you like to use?"
    gets.chomp
  end

  public

  def take_turn
    print "#{name}, please enter your next move >> "
    location = gets.chomp
    column = location[0].upcase.ord - 65
    row = (location[1].to_i - 3).abs # TODO: Change hardcoded calculation to reference row count.
    [column, row, self.symbol]
  end

end

my_board = Board.new(3,3)

puts "What is Player 1's name?"
player1 = Player.new()
puts "Hi, #{player1.name}! You've chosen to use #{player1.symbol}."

puts "What is Player 2's name?"
player2 = Player.new()
puts "Hi, #{player2.name}! You've chosen to use #{player2.symbol}."

loop do
  my_board.update_board(player1.take_turn)
  my_board.update_board(player2.take_turn)
end
