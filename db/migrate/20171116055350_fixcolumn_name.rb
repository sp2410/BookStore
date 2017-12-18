class FixcolumnName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :book_formats, :bookformattype_id, :book_format_type_id
  end
end
