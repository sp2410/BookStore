class BookFormat < ApplicationRecord
  belongs_to :book
  belongs_to :book_format_type

  validates_presence_of :book_id
  validates_presence_of :book_format_type_id


#class methods which provides a gate-way for other classes to communicate through interfaces, thus reducing coupling.   
      
  def self.get_book_format_types(book_id)  	
  	book_formats = self.where(book_id: book_id)  	
  	return book_formats.map {|book_format| self.get_book_format_name_and_physical(book_format.book_format_type_id) }

  end

  def self.get_book_format_name_and_physical(book_format_type_id)
  	BookFormatType.get_book_format_name_and_physical(book_format_type_id)
  end


end
