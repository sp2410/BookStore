class CreateBookFormatTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :book_format_types do |t|
      t.string :name
      t.boolean :physical

      t.timestamps
    end
  end
end
