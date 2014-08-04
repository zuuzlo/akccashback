class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.text :description
      t.integer :amount_cents
      t.references :user, index: true
      t.timestamps
    end
  end
end
