require 'net/http'
class Subway
  include Mongoid::Document
  include Mongoid::Timestamps

  field :start_site, type: String  #起始站点
  field :end_site, type: String  # 结束站点
  field :distance, type:Float  # 距离
  field :price, type:Integer   # 价格
  field :month_increase,type: Integer # 月增加支出
  field :year_increase,type: Integer  # 年增加支出


  def self.find_exist(origin,destination)
    subway = self.where(start_site:origin,end_site:destination).first
    subway = self.where(start_site:destination,end_site:origin).first  unless subway.present?
    return subway
  end


  #查询两个站点之间的距离
  def self.get_distance(origin,destination)
    query = {}
    query[:mode]                = 'transit' #公交模式
    query[:origin]              = origin #起始地点
    query[:destination]         = destination #到达地点
    query[:region]              = '北京'
    query[:origin_region]       = '北京'
    query[:destination_region]  = '北京'
    query[:output]              = 'json' # 输出格式为json
    query[:tactics]             = 11 # 策略为最少时间
    query[:ak]                  = 'A9e3c2846f0b707f92a5c6c54dbd9d11' #api_key
    uri                         = URI('http://api.map.baidu.com/direction/v1')

    uri.query   =  URI.encode_www_form(query)
    res         =  Net::HTTP.get_response(uri) 
    rsult       =  JSON.parse(res.body)

    begin 
     kilometer  =  rsult['result']['routes'][0]['scheme'][0]['distance']
     kilometer  =  kilometer / 1000.0
    rescue
      kilometer = rsult
    end
    return kilometer
  end

  #获取单程票价
  def self.get_price(distance)
    p1 = 3 # 6公里以内 3元
    p2 = 4 # 6到12公里  4元

    p3 = (distance - 12).divmod(10).select{|e| e > 0}.length + p2 #12-32公里每10公里加1元
    p4 = (distance - 32).divmod(20).select{|e| e > 0}.length + p3 #32公里以上每20公里加1元

    return p1 if distance < 6  
    return p2 if distance >= 6 && distance < 12 
    return p3 if distance >= 12 && distance < 32 
    return p4 if distance >= 32     
  end

  def self.get_percent(year_increase)
    count = self.where(:year_increase.lt =>year_increase).count
    ((count  / Subway.count.to_f) * 100).round(1).to_s + '%'
  end

  

  #新增一条查询记录
  def self.create_new(opt)
    self.create(start_site:opt[:origin],end_site:opt[:destination],distance:opt[:distance],price:opt[:price],month_increase:opt[:m_inc],year_increase:opt[:y_inc])
  end

  # 计算每月增加支出
  def self.get_month_increase(price)
    return 22 * (price * 2 - 4)
  end

  #计算每年增加支出
  def self.get_year_increase(price)
    return 22 * 12 * (price * 2 - 4)
  end

  #根据每年的成本计算能买到什么
  def self.get_reward(year_increase)
    case year_increase
    when 528 
      return '一瓶茅台酒'
    when 1056
      return '一瓶迪奥“真我”香水'
    when 1584
      return '一个蔻驰COCAH包'
    when 2112
      return '一部小米4手机'
    when 2640
      return '一部ipad'
    when 3168
      return '一部三星note3手机'
    when 3696 
      return '大半个iPhone6'
    end 
  end


end
