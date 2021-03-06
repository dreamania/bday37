class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  def index
    @users = User.order("id desc").page(params[:page]).per(200)
    @user_counts = User.select(
      "sum(case when users.device = 'pc' then 1 else 0 end) as pc_count, 
      sum(case when users.device = 'mobile' then 1 else 0 end) as mobile_count, 
      count(*) as total_count")
  end
  
  def couponused
    @couponusedusers = User.includes(:coupon)
      .where(:coupons =>{:status => "used"})
      .order("coupons.updated_at DESC")
      .page(params[:page]).per(200)
    @couponused_counts = User.select("
      date(coupons.updated_at) used_date,
      count(*) used_count ")
      .joins(:coupon)
      .where(:coupons =>{:status => "used"})
      .group("date(convert_tz(coupons.updated_at,'+00:00','+09:00'))")
      .order("coupons.updated_at")
    # @coupon_used_counts = User.all.count_by_date()
  end
  
end
