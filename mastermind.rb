require 'pry-byebug'
class Board 
  attr_reader :secret_colors
  attr_accessor :red_pegs, :white_pegs, :game_completed
  def initialize(secret_colors)
    @red_pegs = 0
    @white_pegs = 0
    @secret_colors = secret_colors
    @game_completed = false 
  end
  
  def increment_red 
    @red_pegs += 1
  end 

  def increment_white 
    @white_pegs += 1
  end 
end

class Player 
  def enter_color(position)
    puts "Enter #{position} color"
    print ">"
    gets.chomp
  end


  def colors_sequence
    colors = []
    colors << enter_color("first")
    colors << enter_color("second")
    colors << enter_color("third")
    colors << enter_color("fourth")
    colors 
  end 

  def colors_sequence_comp 
    colors_sequence = []
    colors = ["green", "white", "blue", "green", "yellow", "black", "red", "purple"]
    4.times do 
      colors_sequence << colors.sample
      colors.delete(colors_sequence[-1])
    end
    colors_sequence
  end 
end 

class Codemaker<Player
  attr_reader :board
  def initialize
    @board = nil 
  end

  def create_secret 
    @board = Board.new(colors_sequence)
  end 

  def create_secret_comp
    @board = Board.new(colors_sequence_comp)
  end

  def validate_guess(secret_colors, guessed_colors, board)
    board.red_pegs = 0 
    board.white_pegs = 0
    guessed_colors.each_with_index do |color, index|
      if secret_colors.include? color
        if index == secret_colors.find_index(color)
          board.increment_red 
        else  
          board.increment_white 
        end 
      end 
    end
    if secret_colors == guessed_colors 
      board.game_completed = true 
    end 
  end 

  def validate_guess_comp(secret_colors, guessed_colors, board)
    board.red_pegs = 0 
    board.white_pegs = 0
    $correct_indexes = []
    guessed_colors.each_with_index do |color, index|
      if secret_colors.include? color
        if index == secret_colors.find_index(color)
          board.increment_red
          $correct_indexes << index
        else  
          board.increment_white 
        end 
      end 
    end
    if secret_colors == guessed_colors 
      board.game_completed = true 
    end 
    return guessed_colors 
  end 
  
end 

class Codebreaker<Player
  attr_reader :guessed_colors
  attr_accessor :number_of_guesses
  def initialize
    @guessed_colors = nil
    @number_of_guesses = 0 
  end 
  
  def guess_colors 
    @guessed_colors = colors_sequence 
    @number_of_guesses += 1
  end
   
  def guess_colors_comp 
    if @number_of_guesses == 0
      colors = ["green", "white", "blue", "green", "yellow", "black", "red", "purple"]
      @guessed_colors = []
      4.times do 
        @guessed_colors << colors.sample
        colors.delete(guessed_colors[-1])
      end   
    else  
      @guessed_colors.each_with_index do |color, index|
        colors = ["green", "white", "blue", "green", "yellow", "black", "red", "purple"]
        if !($correct_indexes.include? index) 
          @guessed_colors[index] = colors.sample
        end 
      end
    end 
    @number_of_guesses += 1
  end 
end


codemaker = Codemaker.new 
codebreaker = Codebreaker.new 
p "Choose whether you want to be a codemaker or codebreaker"
print ">"
choice = gets.chomp 
if choice == 'codemaker'
  codemaker.create_secret 
  p codemaker.board.secret_colors
  while codemaker.board.game_completed == false 
    codebreaker.guess_colors_comp
    codemaker.validate_guess_comp(codemaker.board.secret_colors, codebreaker.guessed_colors, codemaker.board)
    p codebreaker.guessed_colors
  end 
else 
  codemaker.create_secret_comp
  p codemaker.board.secret_colors
  while codemaker.board.game_completed == false 
    p 'Codebreaker, enter your guess'
    codebreaker.guess_colors 
    codemaker.validate_guess(codemaker.board.secret_colors, codebreaker.guessed_colors, codemaker.board)
    p "Number of red pegs:" 
    p codemaker.board.red_pegs
    p "Number of white pegs:" 
    p codemaker.board.white_pegs
  end 
end 

p "You have guessed the correct sequence of colors, it took you #{codebreaker.number_of_guesses} guesses"
