require './invalid_move'
require 'colorize'
require 'io/console'
require './pieces'

class Board

  attr_accessor :grid, :white_pieces, :black_pieces, :cursor

  ORDER = [Rook,Knight,Bishop,Queen,King,Bishop,Knight,Rook]

  # instantiates all of the instance variables and poplulates the board with
  # start game setup if it's the original and with a copy if not.
  def initialize(orig = true)
    @white_pieces = Hash.new { |h, k| h[k] = [] }
    @black_pieces = Hash.new { |h, k| h[k] = [] }
    @grid = Array.new(8) { Array.new(8)}
    set_up_board if orig
    @cursor = [6,4]
  end

  # sets up board with start positions.
  def set_up_board


    #pawn setup
    grid[0].map!.with_index {|e,i| e =ORDER[i].new([0,i], :black,self)}
    grid[1].map!.with_index {|e,i| e =Pawn.new([1,i],:black,self)}
    grid[6].map!.with_index {|e,i| e =Pawn.new([6,i],:white,self)}
    grid[7].map!.with_index {|e,i| e =ORDER[i].new([7,i],:white,self)}


    8.times do |col|
      black_pieces[grid[0][col].class] << grid[0][col]
      black_pieces[grid[1][col].class] << grid[1][col]
      white_pieces[grid[6][col].class] << grid[6][col]
      white_pieces[grid[7][col].class] << grid[7][col]
    end

  end

  # pretty print of board.


  # Checks if a player is in check.
  def in_check?(color)
    if color == :black
      king_pos = black_pieces[King][0].pos
      check_list = white_pieces
    else
      king_pos = white_pieces[King][0].pos
      check_list = black_pieces
    end

    check_list.keys.each do |piece_type|
      check_list[piece_type].each do |piece|
        return true if piece.move_dirs.include?(king_pos)
      end
    end

    false
  end

  # Moves a piece on the board
  def move(start, end_pos, player)
    end_x, end_y = end_pos
    start_x, start_y = start

    piece = grid[start_x][start_y]
    destination = grid[end_x][end_y]

    if piece.nil?
      raise InvalidMoveError.new "There is no piece here"
    elsif !piece.move_dirs.include?(end_pos)
      raise InvalidMoveError.new "Piece cannot move here"
    elsif piece.move_into_check?(end_pos)
      raise InvalidMoveError.new "Move puts you in Check"
    end
    unless player.color == piece.color
      raise InvalidMoveError.new "That's not your piece"
    end

    kill_piece(destination)

    grid[end_x][end_y] = piece
    piece.pos = end_pos


    grid[start_x][start_y] = nil



  end

  def move!(start, end_pos)
    start_obj = grid[start.first][start.last]
    end_obj = grid[end_pos.first][end_pos.last]
    start_obj.pos = end_pos

    grid[end_pos.first][end_pos.last] = start_obj
    grid[start.first][start.last] = nil

    kill_piece(end_obj)
  end


  def kill_piece(dead_p)
    unless dead_p.nil?
      pieces = self.black_pieces if dead_p.color == :black
      pieces = self.white_pieces if dead_p.color == :white
      pieces[dead_p.class].each do |piece|
        pieces[piece.class].reject! {|piece| piece.object_id == dead_p.object_id}
      end
    end
  end

  # deep copies a board and returns the copied board
  def dup
    pieces = grid.flatten.compact
    dup_grid = Board.new(false)

    pieces.each do |piece| # TODO refactor with a helper?
      pos_dup = piece.pos.dup
      dup_x, dup_y = pos_dup
      dup_piece = piece.class.new(pos_dup,piece.color,dup_grid)
      dup_grid.grid[dup_x][dup_y] = dup_piece
      dup_grid.black_pieces[dup_piece.class] << dup_piece if piece.color == :black
      dup_grid.white_pieces[dup_piece.class] << dup_piece if piece.color == :white
    end

    dup_grid
  end

  # checks if the current player is in checkmate
  def checkmate?(color)
    if self.in_check?(color)
      if color == :black
        check_list = black_pieces
      else
        check_list = white_pieces
      end

      check_list.keys.each do |piece_type|
        check_list[piece_type].each do |piece|

          if piece.valid_moves.any?
            return false
          end
        end
      end

    else
      return false
    end

    true
  end

  def render
    curs_row, curs_col = cursor if cursor
    pretty_board = grid.dup

    grid.each_with_index do |row, i|

      row.each_with_index do |square, j|

        piece = grid[i][j]
        print_piece = (piece.nil? ? "   " : " #{piece.symbol.to_s} ")
        unless piece.nil?
          piece_col = (piece.color == :white ? :white : :black )
        end


      if curs_row == i && curs_col == j
        backg = :green
        colorp = print_piece.colorize(:color => piece_col, :background => backg)
        print colorp
      elsif (i+j)% 2 == 0
        colorp = print_piece.colorize(:color => piece_col, :background => :red)
        print "#{colorp}"
      else
        colorp = print_piece.colorize(:color => piece_col, :background => :cyan)
        print "#{colorp}"
      end


      end
      puts
    end
  end


end
