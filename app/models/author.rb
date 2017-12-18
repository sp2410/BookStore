class Author < ApplicationRecord
	has_many :books

	validates_presence_of :first_name
	validates_presence_of :last_name


	#class methods which provides a gate-way for other classes to communicate through interfaces, thus reducing coupling.	

	def self.get_author_name_from_id(id)
		author = self.find_by_id(id)
		author == nil ? "Author Record Not Found" : "#{author.first_name.titleize} #{author.last_name.titleize}" 
	end
	
end
