class BookReview < ApplicationRecord
  # belongs_to :customer
  belongs_to :book


  validates_presence_of :rating
  validates_presence_of :book_id

  #class methods which provides a gate-way for other classes to communicate through interfaces, thus reducing coupling.         

  def self.get_average_rating_for_book(book_id)  	
  	book_review_average = self.where(book_id: book_id).average("rating")
  	book_review_average != nil ? book_review_average : "No Reviews Yet!"  	
  end 
  
end
