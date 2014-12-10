class SurveysController < ApplicationController
  def index
  	@title  = '测测你的童年怀旧指数'
    @count = Answer.count
  end
end
