class Guess
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
  field :score,type:Integer
  field :status, type: Integer,default: EDITING
  field :user_id,type:Integer  #答题用户id,直接利用时间戳，存cookie，通过cookie判断用于是否已经答题


  before_save :update_score

  def progress
    qidx = (1..8).to_a.each do |k|
      val = self.send("question_#{k}")
      unless val
        return k
        break
      end
    end
  end


  def update_score
    total = 0
    (1..8).to_a.each do |k|
      t_s = self.send("question_#{k}")
      if t_s
        total += t_s
      end
    end
    self.score = total
    if self.score == 80
      self.status = FINISHD
    end
  end

  def percent
    con1 = Guess.where(:score.lt => self.score).count
    return ((con1 / Guess.count.to_f) * 100).round(1).to_s + '%'
  end

end

