class CreateKohlsCategories < ActiveRecord::Migration
  def change
    create_table :kohls_categories do |t|
      t.string :name
      t.integer :kc_id
      t.string :slug

      t.timestamps
    end
  end
end
