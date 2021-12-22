# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    @time = Time.now
    10.times do
      alphabet = ('A'..'Z').to_a.sample
      @letters << alphabet
    end
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    word['found']
  end

  def word_valid?
    @answer.split('').all? { |letter| @grid.include?(letter) }
  end

  def score
    @grid = params[:grid].split(' ')
    @time = params[:time]
    @answer = params[:word].upcase
    @score = (100 - (Time.now - Time.parse(@time)))

    if word_valid? && english_word?
      @result = 'valid!'
    elsif word_valid? && !english_word?
      @result = 'not an english word!'
      @score = 0
    else
      @result = 'not in the grid!'
      @score = 0
    end
  end
end
