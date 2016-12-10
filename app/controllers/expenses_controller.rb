class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  def index
    @expenses = Expense.all
  end

  # GET /expenses/1
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    t = Time.now
    @now_year = t.strftime("%Y").to_i
    @now_month = t.strftime("%m").to_i
    @now_day = t.strftime("%d").to_i
    @now_oclock = t.strftime("%H").to_i
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  def create
    # merge :paid_at_year, month, day, ampm, and oclock into :paid_at
    tmp_params = expense_params
    if tmp_params[:paid_at_ampm] == "AM" then
      tmp_params[:paid_at] = tmp_params[:paid_at_year] + "-" + tmp_params[:paid_at_month] + "-" + tmp_params[:paid_at_day] + " " + tmp_params[:paid_at_oclock] + ":00:00"
    else
      tmp_params[:paid_at] = tmp_params[:paid_at_year] + "-" + tmp_params[:paid_at_month] + "-" + tmp_params[:paid_at_day] + " " + ((tmp_params[:paid_at_oclock].to_i + 12) % 24).to_s + ":00:00"
    end
    tmp_params.delete(:paid_at_year)
    tmp_params.delete(:paid_at_month)
    tmp_params.delete(:paid_at_day)
    tmp_params.delete(:paid_at_ampm)
    tmp_params.delete(:paid_at_oclock)

    @expense = Expense.new(tmp_params)
    if @expense.save
      redirect_to @expense, notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /expenses/1
  def update
    if @expense.update(expense_params)
      redirect_to @expense, notice: 'Expense was successfully updated.'
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
