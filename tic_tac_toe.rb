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

  def win?
    p 'win? called'
    game_over = false
    board.each do |row|
      p row
      if row.uniq.size == 1 then return true end
    end
    board.transpose.each do |column|
      p column
      if column.uniq.size == 1 then return true end
    end

    if board.flatten.values_at(0,3,6).uniq.size == 1 then game_over = true end
    if board.flatten.values_at(2,5,8).uniq.size == 1 then game_over = true end

    game_over
  end

  def display_board
    board.each do |row|
      row.each { |square| print "|#{square.piece}|" }
      print "\n"
    end
  end

  def update_board(move)
    board[move[1]][move[0]].piece = move[2]
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
  move = player1.take_turn
  my_board.update_board(move)
  move = player2.take_turn
  my_board.update_board(move)
  break if my_board.win? == true
end

puts "The game is over. Somebody won!"
