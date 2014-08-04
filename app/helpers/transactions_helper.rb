module TransactionsHelper
  def available_balance(user)
    available = (user.activities.sum :commission_cents) / 2
    withdrawals = user.transactions.sum :amount_cents
    available - withdrawals
  end
end
