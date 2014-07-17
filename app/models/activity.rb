class Activity < ActiveRecord::Base

  belongs_to :user
  belongs_to :store

  validates :user_id, presence: true
  validates :store_id, presence: true

  def user_name
    User.find(self.user_id).full_name
  end 

  def store_name
    Store.find(self.store_id).name
  end
end
