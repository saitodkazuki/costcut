require "time"

class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # My Method
  def merge_params(tmp_params)
    # merge all into paid_at
    if tmp_params[:paid_at_ampm] == "AM" then
      if tmp_params[:paid_at_oclock] == "12" then
        tmp_params[:paid_at] = tmp_params[:paid_at_year] + "-" + tmp_params[:paid_at_month] + "-" + tmp_params[:paid_at_day] + " 00:00:00"
      else
        tmp_params[:paid_at] = tmp_params[:paid_at_year] + "-" + tmp_params[:paid_at_month] + "-" + tmp_params[:paid_at_day] + " " + tmp_params[:paid_at_oclock] + ":00:00"
      end
    else
      if tmp_params[:paid_at_oclock] == "12" then
        tmp_params[:paid_at] = tmp_params[:paid_at_year] + "-" + tmp_params[:paid_at_month] + "-" + tmp_params[:paid_at_day] + " 12:00:00"
      else
        tmp_params[:paid_at] = tmp_params[:paid_at_year] + "-" + tmp_params[:paid_at_month] + "-" + tmp_params[:paid_at_day] + " " + ((tmp_params[:paid_at_oclock].to_i + 12) % 24).to_s + ":00:00"
      end
    end
    # restructuring
    tmp_params.delete(:paid_at_year)
    tmp_params.delete(:paid_at_month)
    tmp_params.delete(:paid_at_day)
    tmp_params.delete(:paid_at_ampm)
    tmp_params.delete(:paid_at_oclock)
    return tmp_params
  end

  # My Method yesterday(year, month) returns [year, month, day]
  def yesterday(year, month)
    if (month -= 1) == 0 then
      month = 12
      year -= 1
    end
    if [1, 3, 5, 7, 8, 10, 12].include?(month) then
      day = 31
    elsif month == 2 then
      if year % 4 == 0 then
        day = 29
      else
        day = 28
      end
    else
      day = 30
    end
    return [year, month, day]
  end

  # GET /expenses
  def index
    @expenses = Expense.all.order('paid_at DESC')
    @expense = Expense.new

    # for input form
    t = Time.now
    @now_year = t.strftime("%Y").to_i
    @now_month = t.strftime("%m").to_i
    @now_day = t.strftime("%d").to_i
    @now_oclock = t.strftime("%H").to_i

    # for graph
    @graph = Array.new
    graph_year = @now_year # 初期化（グラフ対象日）
    graph_month = @now_month # 初期化（グラフ対象日）
    graph_day = @now_day # 初期化（グラフ対象日）
    graph_amount = 0 # 初期化（グラフ対象日の出費合計）
    day_count = 10 # グラフに表示する日数
    size = @expenses.size
    @expenses.each do |expense|
      if expense.paid_at.strftime("%d").to_i == graph_day then
        # 今回取得したexpenseデータが、グラフ対象日の新規データであれば、加算して保留
        graph_amount += expense.amount
      else
        # グラフ対象日のデータを登録（これまで加算されてきたもの、もしくは0）
        graph_datetime = graph_year.to_s + "-" + graph_month.to_s + "-" + graph_day.to_s + " 00:00:00"
        @graph << [Time.parse(graph_datetime).to_i * 1000, graph_amount]
        # グラフに表示する日数分のデータを登録していたら終了
        if (day_count -= 1) == 0 then
          return
        end
        # 1日前の日付を計算
        graph_day -= 1
        if graph_day == 0 then
          graph_year = yesterday(graph_year, graph_month)[0]
          graph_month = yesterday(graph_year, graph_month)[1]
          graph_day = yesterday(graph_year, graph_month)[2]
        end
        # 今回取得したexpenseデータの日付になるまで全て0で登録
        while (graph_day) != expense.paid_at.strftime("%d").to_i do
          graph_datetime = graph_year.to_s + "-" + graph_month.to_s + "-" + graph_day.to_s + " 00:00:00"
          @graph << [Time.parse(graph_datetime).to_i * 1000, 0]
          # グラフに表示する日数分のデータを登録していたら終了
          if (day_count -= 1) == 0 then
            return
          end
          # 1日前の日付を計算
          graph_day -= 1
          if graph_day == 0 then
            graph_year = yesterday(graph_year, graph_month)[0]
            graph_month = yesterday(graph_year, graph_month)[1]
            graph_day = yesterday(graph_year, graph_month)[2]
          end
        end
        # 今回取得したexpenseデータの日付の分のデータを代入
        graph_amount = expense.amount
      end
      # 今回のデータが、最後のデータであるならば終了
      if (size -= 1) == 0 then
        # 今回のデータがグラフ対象日もしくはその前日のデータであれば登録して終了
        graph_datetime = graph_year.to_s + "-" + graph_month.to_s + "-" + graph_day.to_s + " 00:00:00"
        @graph << [Time.parse(graph_datetime).to_i * 1000, graph_amount]
      end
    end
  end

  # GET /expenses/1/edit
  def edit
    t = @expense.paid_at
    @now_year = t.strftime("%Y").to_i
    @now_month = t.strftime("%m").to_i
    @now_day = t.strftime("%d").to_i
    @now_oclock = t.strftime("%H").to_i
  end

  # POST /expenses
  def create
    @expense = Expense.new(merge_params(expense_params))
    if @expense.save
      redirect_to expenses_url, notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /expenses/1
  def update
    if @expense.update(merge_params(expense_params))
      redirect_to expenses_url, notice: 'Expense was successfully updated.'
    else
      render :edit
    end
  end

  def new
  end

  # DELETE /expenses/1
  def destroy
    @expense.destroy
    redirect_to expenses_url, notice: 'Expense was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def expense_params
      params.require(:expense).permit(:paid_at_year, :paid_at_month, :paid_at_day, :paid_at_ampm, :paid_at_oclock, :amount, :tag)
    end
end
