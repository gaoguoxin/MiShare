class SurveysController < ApplicationController
  def index
    @count = Answer.count
  end
end
