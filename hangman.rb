require 'open-uri'

class Hangman

  @@words = URI.open("https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt").read
  @@words = @@words.split

  def initialize(rounds=15)
    puts "HANGMAN GAME STARTED!"
    @word = @@words.select{ |word| word.size.between?(5,12) }.sample.upcase
    @word_chars = @word.split("")
    print "Continue a previous game? (Y/N) > "
    @continue = gets.chomp.upcase
    @guesses = []
    @errors = 0
    @pause = "N"

    continue_game if @continue == "Y" && File.exists?("guesses.txt")

    until @errors == rounds && @pause == "Y"
      player_try
      puts display
      print "Do you want to pause the game? (Y/N) > "
      @pause = gets.chomp.to_s
    end

    pause_game if @pause == "Y"

    if !display.include?("_ ")
      puts "YOU WIN!"
    else
      puts "YOU LOSE"
    end

  end

  private
  def pause_game
    file_guesses = open("guesses.txt", "w")
    file_errors = open("errors.txt", "w")
    @guesses.each do |guess|
      file_guesses.write(guess)
    end
    file_errors.write(@errors)
    file_guesses.close
    file_errors.close
  end

  def continue_game
    file_guesses = open("guesses.txt", "r").readlines
    file_errors = open("errors.txt", "r").read.to_i
    @errors = file_errors
    file_guesses.each do |guess|
      @guesses << guess
    end
  end

  def display
    word_display = ""
    @word_chars.each do |char|
      if @guesses.include?(char)
        word_display += "#{char} "
      else
       word_display += "_ "
      end
    end
    word_display
  end

  def player_try
    puts "Type a letter"
    print "> "
    letter = gets.chomp.upcase
    if @word.include?(letter)
      puts "Correct guess!"
      @guesses << letter
    else
      puts "Wrong guess!"
      @errors += 1
      puts "You have more #{15 - @errors} chances!"
    end
  end
end

game = Hangman.new
