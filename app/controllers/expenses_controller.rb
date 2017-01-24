class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def merge_params(tmp_params)
    # Merging all params into paid_at
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
    # Restructuring
    tmp_params.delete(:paid_at_year)
    tmp_params.delete(:paid_at_month)
    tmp_params.delete(:paid_at_day)
    tmp_params.delete(:paid_at_ampm)
    tmp_params.delete(:paid_at_oclock)
    return tmp_params
  end

  def yesterday(year, month, day)
    if (day -= 1) == 0 then
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
    end
    return [year, month, day]
  end

  # GET /expenses
  def index
    @expenses = Expense.all.order('paid_at DESC')
    @expense = Expense.new
    @tags = Tag.all
    # For input form
    t = Time.now
    @now_year = t.strftime("%Y").to_i
    @now_month = t.strftime("%m").to_i
    @now_day = t.strftime("%d").to_i
    @now_oclock = t.strftime("%H").to_i
    # For graph
    @graph_xaxis = Array.new
    @graph_yaxis = Array.new
    graph_year = @now_year
    graph_month = @now_month
    graph_day = @now_day
    graph_amount = 0
    day_count = 7 # Size of xaxis
    data_size = @expenses.size
    @expenses.each do |expense|
      if expense.paid_at.strftime("%Y%m%d") == (graph_year.to_s + format("%02d", graph_month) + format("%02d", graph_day)) then
        graph_amount += expense.amount
      else
        @graph_xaxis << graph_month.to_s + "/" + graph_day.to_s
        @graph_yaxis << graph_amount
        if (day_count -= 1) == 0 then
          @graph_xaxis.reverse!
          @graph_yaxis.reverse!
          return
        end
        yesterday = yesterday(graph_year, graph_month, graph_day)
        graph_year = yesterday[0]
        graph_month = yesterday[1]
        graph_day = yesterday[2]
        while expense.paid_at.strftime("%Y%m%d") != (graph_year.to_s + format("%02d", graph_month) + format("%02d", graph_day)) do
          @graph_xaxis << graph_month.to_s + "/" + graph_day.to_s
          @graph_yaxis << 0
          if (day_count -= 1) == 0 then
            @graph_xaxis.reverse!
            @graph_yaxis.reverse!
            return
          end
          yesterday = yesterday(graph_year, graph_month, graph_day)
          graph_year = yesterday[0]
          graph_month = yesterday[1]
          graph_day = yesterday[2]
        end
        graph_amount = expense.amount
      end
      if (data_size -= 1) == 0 then
        @graph_xaxis << graph_month.to_s + "/" + graph_day.to_s
        @graph_yaxis << graph_amount
        @graph_xaxis.reverse!
        @graph_yaxis.reverse!
        return
      end
    end
  end

  # GET /expenses/1/edit
  def edit
    @tags = Tag.all
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
