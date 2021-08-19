class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def guess
    puts "#{@name} please enter a letter"
    guess = gets.chomp.downcase
    puts "#{@name} entered #{guess}"
    guess
  end

  def alert_invalid_guess(letter)
    puts "#{letter} isn't a vaild input"
    puts "Please enter a letter in the alphabet"
  end



end