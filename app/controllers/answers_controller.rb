class AnswersController < ApplicationController

  def check
    answer = Answer.where(user_id:params[:user_id]).first
    data = {exist:false,q_idx:1} #默认值，表示该用户答案不存在，那么从第一题开始显示
    data[:exist] = true if answer
    data[:q_idx] = answer.progress if answer
    data[:score] = answer.score if answer
    render :json => data
  end

  def set_answer
    answer = Answer.where(user_id:params[:user_id]).first
    if answer.present?
      render :json => {success:true,score:answer.score,idx:params[:name]} and return  if answer.update_attributes(params[:name].to_sym => params[:value])
      render :json => {success:false}
    else
      render :json => {success:true} and return  if Answer.create(params[:name].to_sym => params[:value],:user_id => params[:user_id])
      render :json => {success:false} 
    end
  end






  private
    def answer_params
      params.require(:answer).permit(:question_1, :question_2, :question_3, :question_4, :question_5, :question_6, :question_7,:question_8, :question_9, :question_10, :question_11, :question_12, :question_13, :question_14, :question_15, :user_id)
    end
end
