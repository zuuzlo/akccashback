class Activity < ActiveRecord::Base

  belongs_to :user
  belongs_to :store

  validates :user_id, presence: true
  validates :store_id, presence: true

  def user_name
    User.find(self.user_id).user_name
  end 

  def store_name
    Store.find(self.store_id).name
  end

  def user_commission_cents
    commission_cents / 2
  end
end