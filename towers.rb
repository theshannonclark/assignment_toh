class TowerOfHanoi
  def initialize(num_blocks)
    @board = Board.new(num_blocks)
  end

  def play
    print_instructions
    move = get_next_move
    while not game_over? and not move =~ /quit/i
      if @board.valid_move?(move)
        @board.move(move)
        render
      end
      move = get_next_move
    end
  end

  def render
    @board.render
  end

  def get_next_move
    move = ""
    loop do
      print "Enter move > "
      move = STDIN.gets.strip

      break if valid_command?(move)
    end
    return move
  end

  def valid_command?(command)
    command =~ /quit/i or command =~ /^\d,\s?\d$/
  end

  def game_over?
    false
  end

  def print_instructions
    puts "Welcome to Tower of Hanoi!"
    puts "Instructions:"
    puts "Enter where you'd like to move from and to in the format '1,3'. Enter 'q' to quit."

    render
  end
end

class Board
  attr_reader :num_blocks

  def initialize(num_blocks)
    @num_blocks = num_blocks
    @towers = [@num_blocks, 0, 0]
  end

  def render
    puts "Current board:"
    puts "#{@towers[0]} #{@towers[1]} #{@towers[2]}"
  end

  def parse_move(move)
    parts = move.split(",")
    return parts[0].strip.to_i - 1, parts[1].strip.to_i - 1
  end

  def valid_move?(move)
    from, to = parse_move(move)
    valid = true
    if (not (0..2).include?(from)) or (not (0..2).include?(to))
      valid = false
    elsif @towers[from] == 0
      valid = false
    end
    return valid
  end

  def move(move)
    from, to = parse_move(move)
    @towers[from] -= 1
    @towers[to] += 1
  end
end

def valid_num_blocks(string)
  string =~ /^[+-]?\d+(\.\d+)?$/ and (1..10).include?(string.to_i)
end

if $0 == __FILE__
  cli_arguments = ARGV
  if (cli_arguments.length >= 1) and (valid_num_blocks(cli_arguments[0]))
    num_blocks = cli_arguments[0]
  else
    loop do
      print "How many blocks do you want on the tower? (enter a number between 1 and 10) > "
      # thanks to http://stackoverflow.com/a/27453657
      num_blocks = STDIN.gets.strip

      break if valid_num_blocks(num_blocks)
    end
  end

  t = TowerOfHanoi.new(num_blocks.to_i)
  t.play
end