class AnimalsController < ApplicationController
	before_action :get_title
	def index
		@count = Animal.count
	end

	def answer
		if params[:user_id].present?
			@animal = Animal.where(user_id:params[:user_id]).last
		end
	end

	def set_answer
    	animal = Animal.where(user_id:params[:user_id],status:Animal::EDITING).first
    	if animal.present?
    	  animal.update_attributes(params[:name].to_sym => params[:value])
    	  render :json => {success:true,q_idx:animal.progress}
    	else
    	  animal = Animal.create(params[:name].to_sym => params[:value],:user_id => params[:user_id])		
    	  render :json => {success:true,q_idx:animal.progress}
    	end		
	end

	def result
		@animal = Animal.where(user_id:params[:user_id]).last
		@animal.update_attributes(status:Animal::FINISHD) if @animal.present?
	end

	#检查是否存在当前用户的答案
	def check
		@animal = Animal.where(user_id:params[:user_id]).last
		if @animal.present? && @animal.status == Animal::EDITING
			render :json => {continue:true,q_idx:@animal.progress}
		else
			render :json => {continue:false}
		end
	end

	private
	def get_title
		@title = 'MBTI性格分析:看看你是哪种动物?超准!'
	end
end