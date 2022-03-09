require 'open-uri'

class Hangman

  @@words = URI.open("https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt").read
  @@words = @@words.split

  def initialize(rounds=15)
    puts "HANGMAN GAME STARTED!"
    @word = @@words.select{ |word| word.size.between?(5,12) }.sample.upcase
    @word_chars = @word.split("")
    @guesses = []
    @errors = 0

    until @errors == 15
      player_try
      puts display
    end

    if !display.include?("_ ")
      puts "YOU WIN!"
    else
      puts "YOU LOSE"
    end

  end

  private
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
