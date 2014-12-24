class Animal
  include Mongoid::Document
  include Mongoid::Timestamps

  EDITING   = 0 # 正在答题
  FINISHD   = 1 # 答题完成



  field :question_1, type: String
  field :question_2, type: String
  field :question_3, type: String
  field :question_4, type: String
  field :status, type: Integer,default: EDITING
  field :user_id,type:Integer  #答题用户id,直接利用时间戳，存cookie，通过cookie判断用于是否已经答题

  before_save :update_status

  #判断某个用户该回答第几题(主要用于用户中断答题后继续答题)
  def progress
    qidx = (1..4).to_a.each do |k|
      val = self.send("question_#{k}")
      unless val
        return k
        break
      end
    end
  end


  def update_status
    if self.question_4
      self.status = FINISHD
    end
  end

  def result
    return "#{question_1}#{question_2}#{question_3}#{question_4}"
  end


end
