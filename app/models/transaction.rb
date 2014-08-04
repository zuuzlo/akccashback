class Transaction < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validate :amount_cannot_be_more_than_available, if: :user_id

  def amount_cannot_be_more_than_available
    withdrawals = Transaction.where("user_id = :user_id AND description = :description", {user_id: user_id, description: "Withdrawal"}).sum :amount_cents
    
    if amount_cents > Activity.find_by_user_id(user_id).user_commission_cents - withdrawals
      errors.add( :amount_cents, "can't be more than you have")
    end
  end
end
