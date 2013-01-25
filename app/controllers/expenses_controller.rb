class ExpensesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:show, :destroy]

  def create
   @expemse = Expense.new 

   prefs={}
   prefs["type"]=params[:expense][:type]
   prefs["recurrence"]=params[:expense][:recurrence]
   store_prefs prefs

   redirect_to expenses_path
  end

  def index
    @expense = Expense.new 
    @expenses = current_user.expenses.find(:all, :joins => :label, :order => 'labels.name')

    #info
    @balance = current_user.balance

    @recurrence_fraction=recurrence_fraction
    @period=selected_period

    total=current_user.totals_of(selected_period)
    @recieved=total[:received]
    @paid=total[:paid]
    @total=total[:received]-total[:paid]
    @pendent = total[:unpaid]
    @budget = total[:estimate]/recurrence_fraction
  end

  def show
    store_location
    @expense = current_user.expenses.find_by_id(params[:id])
    @tracks = current_user.expenses.find_by_id(params[:id]).tracks.paginate(page: params[:page], per_page: 10)
    #@expense = Expense.find(params[:id])
  end

  def destroy
    current_user.expenses.find_by_id(params[:id]).destroy
    flash[:success] = "Expense destroyed."
    redirect_to expenses_url
  end

  private

    def correct_user
      @expense = current_user.expenses.find_by_id(params[:id])
      redirect_to root_url if @expense.nil?
    end
end