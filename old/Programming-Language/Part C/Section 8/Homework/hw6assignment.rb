# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# Enhancement 1: press `u` => rotate 180 degrees
# Enhancement 2: 7 pieces => 10 pieces
# Enhancement 3: `c` => if score >= 100: next piece is specific, score -= 100

class MyPiece < Piece
  # Enhancement 2: class array holding all the pieces and their rotations
  All_My_Pieces = [rotations([[0, 0], [-1, 0], [-1, -1], [0, -1], [1, 0]]), # square with tail: 5
                  [[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]],
                  [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]], # long: 5
                  # L-short: 3
                  rotations([[0, 0], [0, -1], [1, 0]])] + All_Pieces

  # Enhancement 2: use All_My_Pieces
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  # Enhancement 3: get a cheat piece
  def self.next_cheat_piece (board)
    MyPiece.new([[[0, 0]]], board)
  end

end

class MyBoard < Board
  def initialize (game)
    # determine if cheat next time
    @cheat = false
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    # use MyPiece
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
  end

  # Enhancement 1: rotate 90 degrees 2 times
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # Enhancement 3: use cheat piece
  def next_cheat
    if @score >= 100 and !@cheat
      @cheat = true
      @score -= 100
    end
  end

  # Enhancement 3: use cheat or not in next_piece
  def next_piece
    if @cheat
      @current_block = MyPiece.next_cheat_piece(self)
      @cheat = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  # Enhancement 2: fix bug while dropping NEW pieces whose size is not 4
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    # locations.size is the number of blocks in the piece
    (0..(locations.size - 1)).each{|index|
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  def set_board
    @canvas = TetrisCanvas.new
    # use myBoard
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    # Enhancement 1: add to key bindings
    @root.bind('u', proc {@board.rotate_180})
    # Enhancement 3: add to key bindings
    @root.bind('c', proc {@board.next_cheat})
  end

end