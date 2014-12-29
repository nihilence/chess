require './board'
require './humanplayer.rb'


class Game
  attr_accessor :chess_board, :grid, :current
  attr_reader   :black_player, :white_player

  def initialize(player1, player2)
    @white_player = player1
    @black_player = player2
    @chess_board = Board.new
    assign_colors
    @current = white_player
  end

  def assign_colors
    white_player.color , black_player.color = :white, :black
  end

  def game_over?(color)
    chess_board.checkmate?(color)
  end

  def end_game
    @current = ( current == white_player ? black_player : white_player )


    puts "#{current.color} won!"
  end


  def play
    checkmate = false


    until checkmate
      message = nil

        begin
          x,y = pick(message)
          message = nil
          piece = chess_board.grid[x][y]

          if piece.nil?
            piece = [@chess_board.cursor.first, @chess_board.cursor.last]
          else
            piece = @chess_board.grid[x][y].pos
          end

          to = pick(message)

          @chess_board.move([x,y], to, @current)
          @chess_board.cursor =[4,4]
          @current = ( current == white_player ? black_player : white_player )
          checkmate = true if game_over?(@current)

        rescue InvalidMoveError => e
          message = e
          retry
        end
      end
      end_game
    end

  def pick(msg)
    loop do
      system("clear")


      puts "#{@current.color.upcase} PLAYER:"
      puts msg
      @chess_board.render
      input = STDIN.getch



      case input
        when "w"
          @chess_board.cursor[0] -= 1 if @chess_board.cursor[0] > 0

        when "s"
          @chess_board.cursor[0] += 1 if @chess_board.cursor[0] < 7

        when "d"
          @chess_board.cursor[1] += 1 if @chess_board.cursor[1] < 7

        when "a"
          @chess_board.cursor[1] -= 1 if @chess_board.cursor[1] > 0

        when " "

          return @chess_board.cursor
        when "q"
          exit
        end
      end


  end



end
