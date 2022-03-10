require 'open-uri'

class Hangman

  @@words = URI.open("https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt").read
  @@words = @@words.split

  def initialize
    puts "HANGMAN GAME STARTED!"
    @word = @@words.select{ |word| word.size.between?(5,12) }.sample.upcase
    @word_chars = @word.split("")
    print "Continue a previous game? (Y/N) > " if File.exists?("guesses.txt")
    @continue = gets.chomp.upcase if File.exists?("guesses.txt")
    @guesses = []
    @errors = 0
    @pause = "N"

    continue_game if @continue == "Y" && File.exists?("guesses.txt")

    until @errors == 15 && @pause == "Y"
      puts display
      player_try
      break if @errors >= 15
      print "Do you want to pause the game? (Y/N) > " if display.include?("_ ")
      @pause = gets.chomp.to_s if display.include?("_ ")
      break if @pause == "Y" || !display.include?("_ ")
    end

    pause_game if @pause == "Y"

    if @errors >= 15 || !display.include?("_ ")
      if !display.include?("_ ")
        puts "Game finished! YOU WIN!"
        File.delete("guesses.txt") if File.exist?("guesses.txt")
        File.delete("errors.txt") if File.exist?("errors.txt")
        File.delete("word_chars.txt") if File.exist?("word_chars.txt")
      else
        puts "Game over!"
        File.delete("guesses.txt") if File.exist?("guesses.txt")
        File.delete("errors.txt") if File.exist?("errors.txt")
        File.delete("word_chars.txt") if File.exist?("word_chars.txt")
      end
    end
  end

  private
  def pause_game
    file_errors = open("errors.txt", "w")
    file_errors.write(@errors)
    file_errors.close
    file_guesses = open("guesses.txt", "w")
    @guesses.each do |guess|
      file_guesses.write(guess)
    end
    file_guesses.close
    word_chars_save = open("word_chars.txt", "w")
      @word_chars.each do |char|
      word_chars_save.write(char)
    end
    word_chars_save.close
  end

  def continue_game
    file_errors = open("errors.txt", "r").read.to_i
    @errors = file_errors
    file_chars = open("word_chars.txt", "r").read
    @word = file_chars.upcase
    @word_chars = @word.split("")
    file_guesses = open("guesses.txt", "r").read.split("")
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
