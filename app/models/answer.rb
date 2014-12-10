class Answer   # 童年小调查
  include Mongoid::Document
  include Mongoid::Timestamps

  EDITING   = 0 # 正在答题
  FINISHD   = 1 # 答题完成

  field :question_1, type: Integer
  field :question_2, type: Integer
  field :question_3, type: Integer
  field :question_4, type: Integer
  field :question_5, type: Integer
  field :question_6, type: Integer
  field :question_7, type: Integer
  field :question_8, type: Integer
  field :question_9, type: Integer
  field :question_10, type: Integer
  field :question_11, type: Integer
  field :question_12, type: Integer
  field :question_14, type: Integer
  field :question_13, type: Integer
  field :question_15, type: Integer
  field :score,type:Integer
  field :status, type: Integer,default: EDITING
  field :user_id,type:Integer  #答题用户id,直接利用时间戳，存cookie，通过cookie判断用于是否已经答题

  before_save :update_score
  
  #判断某个用户该回答第几题(主要用于用户中断答题后继续答题)
  def progress
    qidx = (1..15).to_a.each do |k|
      val = self.send("question_#{k}")
      unless val
        return k
        break
      end
    end
  end

  def update_score
    total = 0
    (1..15).to_a.each do |k|
      t_s = self.send("question_#{k}")
      if t_s
        total += t_s
      end
    end
    self.score = total
  end

  def percent
    con1 = Answer.where(:score.lt => self.score).count
    return ((con1 / Answer.count.to_f) * 100).round(1).to_s + '%'
  end
end
