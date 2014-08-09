class TransactionsController < ApplicationController
  before_filter :require_user, only:[:new, :create]
  
  def new
    @user = current_user
    @activity = @user.activities
    @transactions = @user.transactions
    @transaction = Transaction.new
  end

  def create
    @user = User.friendly.find(params[:user_id])
    cents = (params[:transaction][:amount_cents].to_f * 100).to_i
    params[:transaction][:amount_cents] = cents
    @transaction = @user.transactions.build(transaction_params.merge!(user: current_user))

    if @transaction.save
      AppMailer.delay.notify_transaction(@user, @transaction)
      flash[:success] = "You a successfuly made a withdrawl, please wait 24 hours to see amount in your paypal account."
      redirect_to  new_user_transaction_path(@user)
    else
      @activity = @user.activities.reload
      @transactions = @user.transactions.reload
      render :new
    end
   
  end

  private

  def transaction_params
    params.require(:transaction).permit(:user_id, :amount_cents, :description)
  end
end