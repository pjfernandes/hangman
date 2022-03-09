require 'open-uri'

class Hangman

  @@words = URI.open("https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt").read
  @@words = @@words.split

  def initialize
    puts "HANGMAN GAME STARTED!"
    @word = @@words.select{ |word| word.size.between?(5,12) }.sample.upcase
    @word_chars = @word.split("")
    @guesses = []
  end

  def display
    @word_chars.each do |char|
      if @guesses.include?(char)
        print char
      else
       print "_ "
      end
    end
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
    end

  end


end
