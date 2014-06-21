class CreateKohlsTypes < ActiveRecord::Migration
  def change
    create_table :kohls_types do |t|
      t.string :name
      t.integer :kc_id
      t.string :slug

      t.timestamps
    end
  end
end
