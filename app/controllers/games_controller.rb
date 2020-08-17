require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @grid = [params[:grid], params[:word]]
    @result = run_game(params[:word], params[:grid])
  end

  def generate_grid(grid_size)
    grid_size.times.map { ('A'..'Z').to_a.sample }
  end

  def run_game(attempt, grid)
    answer = generate_answer(attempt)
    if answer['found'] == false
      { score: 0, message: " #{attempt} in #{grid} is not an english word" }
    elsif answer['found'] == true && check(grid, attempt) == true
      score = answer['length']
      { score: score, message: " #{attempt} in #{grid} is correct well done" }
    else
      { score: 0, message: " #{attempt} was not in the grid #{grid}" }
    end
  end

  def check(grid, attempt)
    word = attempt.upcase.split('')
    formated = grid.gsub(' ', '')
    formated = formated.split('')
    word.each do |letter|
      if formated.include? letter
        formated.delete_at(formated.index(letter))
      else
        return false
      end
    end
    true
  end

  def generate_answer(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    generator = open(url).read
    JSON.parse(generator)
  end
end
