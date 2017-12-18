class BookFormatType < ApplicationRecord

	validates_presence_of :name

	has_many :book_formats

	has_many :books, :through => :book_formats

	#class methods which provides a gate-way for other classes to communicate through interfaces, thus reducing coupling.         

	def self.get_book_format_name_and_physical(id)		
		book_format_type = self.find_by_id(id)
		book_format_type ? {:name => book_format_type.name.titleize, :physical => book_format_type.physical} : "Book Format Type Record Not Found"
	end	



	#Extra class methods if needed

	def self.get_book_format_name(id)
		book_format_type = self.find_by_id(id)
		book_format_type ? book_format_type.name.titleize : "Book Format Type Record Not Found"
	end

	def self.book_is_physical(id)		
		book_format_type = self.find_by_id(id)
		book_format_type ? book_format_type.physical : "Book Format Type Record Not Found"
	end
	
end
