class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:calendars).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []
    #  Planテーブルのdateカラムから今日の日付＋6日を探してきてplansに代入
    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      
      plan = plans.map do |plan|     #mapで一週間を1日ずつ回す　変数planは1日
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end   #↑もしその日の日にちがx日と同じならplanを追加します。

      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans}
      @week_days.push(days)
    end

  end
end
