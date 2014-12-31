class GuessesController < ApplicationController
  before_action :get_title

  #检查是否存在当前用户的答案
  def check
    @guess = Guess.where(user_id:params[:user_id]).last
    if @guess.present? && @guess.status == Guess::EDITING
      render :json => {continue:true,idx:@guess.progress}
    else
      render :json => {continue:false}
    end
  end

  def index
    @count = Guess.count
  end

  def show

  end

  def create
    guess = Guess.where(user_id:params[:user_id],status:Guess::EDITING).last
    unless guess.present?
      render :json => {success: Guess.create(params[:name].to_sym => params[:value],:user_id => params[:user_id])}   
    else
      render :json => {success: guess.update_attributes(params[:name].to_sym => params[:value])} 
    end
  end

  def result
    @guess = Guess.where(user_id:params[:user_id]).last
    @guess.update_attributes(status:Guess::FINISHD) if @guess.present?    
  end

  private
    def get_title
      @title = '猜猜我是谁'
    end

end








