class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.references :customer, foreign_key: true
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
