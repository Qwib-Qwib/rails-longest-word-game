require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters.push(('A'..'Z').to_a.sample) }
    params[:letters] = @letters
  end

  def score
    params[:suggestion] = params[:suggestion].upcase
    @message = if can_be_built? == false
                 "Sorry, but #{params[:suggestion]} can't be built out of #{params[:grid]}."
               elsif english? == false
                 "Sorry, but #{params[:suggestion]} does not seem to be a valid English word..."
               else
                 "Congratulations! #{params[:suggestion]} is a valid English word!"
               end
  end

  private

  def can_be_built?
    params[:grid] = params[:grid].split(' ')
    grid_copy = params[:grid].dup
    params[:suggestion].each_char do |letter|
      return false if grid_copy.include?(letter) == false

      grid_copy.delete_at(grid_copy.index(letter))
    end
  end

  def english?
    json = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{params[:suggestion]}").read)
    json['found']
  end
end
