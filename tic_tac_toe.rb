class Board
  def initialize(number_of_rows, number_of_columns)
    @number_of_rows = number_of_rows
    @number_of_columns = number_of_columns

    create_board
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
    @number_of_columns.times { squares << Square.new() }
    squares
  end

  public

end

my_board = Board.new(3,3)
