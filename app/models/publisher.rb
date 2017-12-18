class Publisher < ApplicationRecord
	has_many :books

	validates_presence_of :name

	#class methods which provides a gate-way for other classes to communicate through interfaces, thus reducing coupling.         

	def self.get_publisher_name_from_id(publisher_id)
		publisher = self.find_by_id(publisher_id)
		publisher == nil ? "Publisher Record Not Found" : "#{publisher.name.titleize}" 		
	end

end
