class LyricsController < ApplicationController
	before_action :get_title
	def index
		@count = Lyric.count
	end

	def answer
		if params[:user_id].present?
			@lyric = Lyric.where(user_id:params[:user_id]).last
		end
	end

	def set_answer
    	lyric = Lyric.where(user_id:params[:user_id],status:Lyric::EDITING).first
    	if lyric.present?
    	  render :json => {success:true,continue:params[:value].to_i,q_idx:lyric.progress} and return  if lyric.update_attributes(params[:name].to_sym => params[:value])
    	  render :json => {success:false}
    	else
    	  lyric = Lyric.create(params[:name].to_sym => params[:value],:user_id => params[:user_id])		
    	  render :json => {success:true,continue:params[:value].to_i,q_idx:lyric.progress} and return  if  lyric
    	  render :json => {success:false} 
    	end		
	end

	def result
		@lyric = Lyric.where(user_id:params[:user_id]).last
		@lyric.update_attributes(status:Lyric::FINISHD) if @lyric.present?
	end

	#检查是否存在当前用户的答案
	def check
		@lyric = Lyric.where(user_id:params[:user_id]).last
		if @lyric.present? && @lyric.status == Lyric::EDITING
			render :json => {continue:true,q_idx:@lyric.progress}
		else
			render :json => {continue:false}
		end
	end

	private
	def get_title
		@title = '我爱记歌词'
	end
end