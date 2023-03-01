> A file records the APIs.

`Piece`:
* initialize (point_array, board)
* move (delta_x, delta_y, delta_rotation): return (move is possible)
  * potential: (@rotation_index + delta_rotation) % @all_rotation.size
    check if rotation is valid, via checking every elements in the array
  * use local variable `move` to decide whether to change state or not
* All_Pieces: the array of all possible pieces

`Board`:
* initialize (game)

`Tetris`:
* initialize
* key_bindings
* update_score