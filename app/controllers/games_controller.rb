require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    array_of_letters = ("a".."z").to_a
    10.times do
      @letters.push(array_of_letters.sample)
    end
  end

  def score
    if session[:mainScore]
      @mainScore = session[:mainScore].to_i
    else
      @mainScore = 0
    end

    myword = params[:myWord].chars
    lettres = params[:allLetters]
    lettresArray = lettres.split(/,/)
    b = lettresArray.map(&:clone)

    hasGoodNumberLetter = true

    myword.each do |letr|
      hasGoodNumberLetter = true
      if b.include?(letr)
      b.delete_at(b.index(letr))
      else
        hasGoodNumberLetter = false
        break
      end
    end

    info = URI.open("https://wagon-dictionary.herokuapp.com/#{myword.join}").read
    infos = JSON.parse(info)
    wordExists = infos["found"]

    if wordExists === true && hasGoodNumberLetter
      @result = "Congratulation ! #{ myword.join.upcase } is a valid word."
    elsif !wordExists === true
      @result = "#{ myword.join.upcase } is not an English word..."
    else
      @result = "The word is not contained in the 10 original letters."
    end

    if @result === "Congratulation ! #{ myword.join.upcase } is a valid word."
      @mainScore += myword.join.upcase.length
      session[:mainScore] = @mainScore
    end
  end
end
