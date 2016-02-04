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

end

class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end

  

end

my_board = Board.new(3,3)
