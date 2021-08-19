require "byebug"
require "./player.rb"

class Game

  attr_reader :dictionary, :fragment, :players, :current_player

  def initialize(*players)
    words = File.readlines("dictionary.txt").map(&:chomp)
    @players = players.map { |player_name| Player.new(player_name)}
    @loses = Hash.new { |loses,player| loses[player] = 0 }
    @fragment = ""
    @dictionary = Hash.new { |word| @dictionary[word] = "txt"} 
    words.each { |word| @dictionary[word] = "txt"} 
  end

  def switch_turns
    @players.rotate!
  end

  def current_player
    @players.first
  end

  def player_delete
    @players.delete_if { |player| @loses[player] == 5}
  end


  def whos_turn
    puts "#{current_player} it is your turn"
  end

  def add_fragment(letter)
    @fragment << letter
  end


  def valid_play?(letter)
    alp = ("a".."z").to_a
    return false if !alp.include?(letter)
    pos_frag = @fragment + letter
    dictionary.keys.any? { |word| word.downcase.start_with?(pos_frag)}
  end

  def winner
    puts "#{@players.first.name} you win!"
  end

  def game_over
    return true if remaining_players == 1
    false
  end

  def remaining_players
    @players.length
  end

  def loses_rounds_count
    @loses[current_player]
  end


  def lose_round
    if self.is_word?
      @loses[current_player] += 1 
      puts "#{current_player.name} you lost this round"
      @fragment = ""
    end
  end

  def not_valid(guess)
    current_player.alert_invalid_guess(guess)
  end

  def is_word?
    @dictionary.keys.any? { |word| word == @fragment}
  end

  def run
    until game_over
      turn
      lose_round
      if loses_rounds_count == 5
        puts "#{current_player.name} was eliminated"
        player_delete
      end
      switch_turns      

    end
    winner
  end

  def turn
    guess = nil

    until guess

      guess = current_player.guess

      while !valid_play?(guess)
      
        not_valid(guess)
        guess = nil
        guess = current_player.guess
      end
    end

      add_fragment(guess)
  end


end


if $PROGRAM_NAME == __FILE__
  game = Game.new("kevin", "jim", "bob", "frank")
  game.run
  
end