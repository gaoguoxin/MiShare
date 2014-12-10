class SubwaysController < ApplicationController
  before_action :get_title
  def index
    @qtime = Subway.count
  end


  def info
    subway       = Subway.find_exist(params[:origin],params[:destination])
    @origin      = params[:origin]
    @destination = params[:destination]

    if subway.present?
      @distance       = subway.distance
      @price          = subway.price
      @year_incrase   = subway.year_increase
      @month_increase = subway.year_increase
    else
      @distance       = Subway.get_distance(params[:origin],params[:destination]) # 距离(公里)
      @price          = Subway.get_price(@distance) # 单价(元)
      @month_increase = Subway.get_month_increase(@price) # 每月多出的支出
      @year_incrase   = Subway.get_year_increase(@price) # 每年多出的支出
    end
    @reward  = Subway.get_reward(@year_incrase)
    @percent = Subway.get_percent(@year_incrase )
    
    new_subway
  end


  private 

  #创建一条新的查询记录
  def new_subway
    new_param = {}
    new_param[:origin] = params[:origin]
    new_param[:destination] = params[:destination]
    new_param[:distance] = @distance
    new_param[:price] = @price
    new_param[:m_inc] = @month_increase
    new_param[:y_inc] = @year_incrase
    Subway.create_new(new_param)    
  end

  def get_title
    @title  = '测测你的出行成本'
  end


end
