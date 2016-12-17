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

    #for graph
    @graph = Array.new
    graph_month = @now_month
    graph_day = @now_day
    graph_amount = 0
    count = 7
    @expenses.each do |expense|
      if expense.paid_at.strftime("%d").to_i == graph_day then
        graph_amount += expense.amount
      else
        loop do
          # graph_date = graph_year.to_s + "-" + graph_month.to_s + "-" + graph_day.to_s
          @graph << [count, graph_amount]
          # break?
          count -= 1
          if count == 0 then
            break
          end
          # update graph_day, graph_amount
          graph_day -= 1
          graph_amount = 0
          if expense.paid_at.strftime("%d").to_i == graph_day then
            graph_amount = expense.amount
            next
          end
          if graph_day == 0 then
            graph_month -= 1
            if graph_month == 0 then
              graph_month == 12
            end
            if [1, 3, 5, 7, 8, 10, 12].include?(graph_month) then
              graph_day = 31
            elsif graph_month == 2 then
              if @now_year % 4 == 0 then
                graph_day = 29
              else
                graph_day = 28
              end
            else
              graph_day = 30
            end
          end
        end
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
