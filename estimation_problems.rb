#!/usr/bin/env ruby

class EstimationProblem
  def initialize(left_factor, right_factor)
    @left_factor = left_factor
    @right_factor = right_factor
  end

  def to_s
     s =<<-EOP
       #{@left_factor}
     * #{@right_factor}
     ______________
     EOP
     return s
  end

  def estimated_right
    # round to greatest place-value
    # -1 => 10's
    # -2 => 100's
    # -3 => 1000's
    # -4 => 10000's
    unless @estimated_right
      if @right_factor < 100
        rounding_value = -1
      elsif @right_factor < 1000
        rounding_value = -2
      elsif @right_factor < 10000
        rounding_value = -3
      elsif @right_factor < 100000
        rounding_value = -4
      else
        rounding_value = -5
      end
      @estimated_right = @right_factor.round(rounding_value)
    end
    @estimated_right
  end

  def estimated_left
    unless @estimated_left
      if @left_factor < 100
        rounding_value = -1
      elsif @left_factor < 1000
        rounding_value = -2
      elsif @left_factor < 10000
        rounding_value = -3
      elsif @left_factor < 100000
        rounding_value = -4
      else
        rounding_value = -5
      end
      @estimated_left = @left_factor.round(rounding_value)
    end
    @estimated_left
  end

  def actual_product
    @actual_product ||= @left_factor * @right_factor
  end

  def estimated_product
    estimated_product ||= estimated_left * estimated_right
  end

  def right_answer?(guess)
    guess.to_i == estimated_product
  end
end

if __FILE__ == $PROGRAM_NAME
  problem_params = [
      [227, 354.5],
      [532, 633],
      [563, 325],
      [566, 457],
      [314, 147],
      [564, 327],
      [5321, 6352],
      [6356, 3635],
      [1234, 2135],
      [5362, 4146],
  ]

  problems = problem_params.map { |params| EstimationProblem.new(*params) }
  problems.each_with_index do |problem, idx|
    tries = 3
    guess = nil
    while tries > 0 && (!problem.right_answer?(guess))
      puts "#{idx}) #{problem}"
      guess = gets.chomp
      tries -= 1
    end
    puts <<-DETAILS
      estimated left_factor: #{problem.estimated_left}
      estimated right_factor: #{problem.estimated_right}
      estimated_product: #{problem.estimated_product}
      actual_product: #{problem.actual_product}
    DETAILS
  end
end
