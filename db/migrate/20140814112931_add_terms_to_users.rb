class AddTermsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms, :boolean
    User.find_each do | user |
      user.terms = true
      user.save!
    end
  end
end
