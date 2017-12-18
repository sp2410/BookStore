class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher

  has_many :book_formats
  has_many :book_reviews
  
  has_many :book_format_types, :through => :book_formats

  validates_presence_of :title
  validates_presence_of :author_id
  validates_presence_of :publisher_id

  has_many :book_format_types, :through => :book_formats



  #elastic search settings:
  # searchkick 

  # def search_data
  #   attributes.merge(
  #     title: title,
  #     last_name: author(&:last_name),
  #     publisher_name: publisher(&:name),
  #   )
  # end
 

#-------------------------

#instance methods:

  def book_format_types
    get_book_format_types(self.id)
  end  

  def author_name
    get_author_name(self.author_id)
  end

  def author_name2
    "#{author.last_name} + #{author.first_name}"
  end

  def average_rating
    get_average_rating(self.id)
  end


  
  #Although it was asked to create a search method but for differentiation and handling problems with elastic search search, 
  #I felt the need for renaming this method to sql_search instead. 

  # After benchmarking on the production server, we can choose to use the most suited (memory and performance) searches below and 
  #name it as search.


  #If data size is small, use this simple sql based searching which is default here. 
  def self.sql_search(query, args = {})

    title_only, book_format_type_id, book_format_physical, query  = (args[:title_only] || false), args[:book_format_type_id], args[:book_format_physical], query.to_s   
    books = title_only == true ? self.search_match_title_true(query) : self.search_match_title_false(query)
    return self.execute_filters_according_to_arguments(books, book_format_type_id, book_format_physical)

  end



#ELASTIC SEARCH
  
  #If data size is huge or sql text searching is slow, use this search accelarated by elastic search.
  # def self.search_instead_with_elastic_search(query, args = {})
    
  #   title_only, book_format_type_id, book_format_physical  = (args[:title_only] || false), args[:book_format_type_id], args[:book_format_physical]
  #   books = title_only == true ? self.search_match_title_true_elastic_search(query) : self.search_match_title_false_elastic_search(query)
  #   return self.execute_filters_according_to_arguments(books, book_format_type_id, book_format_physical)
  # end


  #helper class methods for sql searching

  def self.search_match_title_true(query)      
      return self.joins(:author).joins(:publisher).where("LOWER(books.title) LIKE ?", "%#{query.downcase}%")      
  end

  def self.search_match_title_false(query)      
      return self.joins(:author).joins(:publisher).where("LOWER(books.title) LIKE ? OR LOWER(authors.last_name) = ? or LOWER(publishers.name) = ?", "%#{query.downcase}%", query.downcase, query.downcase)
  end

  def self.execute_filters_according_to_arguments(books, book_format_type_id, book_format_physical)
    books = self.execute_book_format_type_and_book_format_physical_filters(books, book_format_type_id, book_format_physical)
    books = self.order_and_make_results_unique(books)
    return books
  end

  def self.execute_book_format_type_and_book_format_physical_filters(books, book_format_type_id, book_format_physical)
    books = (books.joins(:book_format_types).where("book_format_types.id = ? AND book_format_types.physical = ?", book_format_type_id, book_format_physical)) if (book_format_type_id != nil and book_format_physical != nil)
    books = (books.joins(:book_format_types).where("book_format_types.id = ? ", book_format_type_id)) if book_format_type_id != nil and book_format_physical == nil
    books = (books.joins(:book_format_types).where('book_format_types.physical = ?', book_format_physical)) if book_format_type_id == nil and book_format_physical != nil
    return books
  end

  def self.order_and_make_results_unique(books)
    return books.left_outer_joins(:book_reviews).select("books.*, avg(book_reviews.rating) as average_rating, count(book_reviews.id) as number_of_reviews").group("books.id").order("average_rating DESC, number_of_reviews DESC").uniq
  end



  #helper class methods for elastic search, other methods are same as sql search (Since books and author are the only one in 100000+)

  def self.search_match_title_true_elastic_search(query)      
    #Search all the specified fields
      self.search(query, fields: [:title]).records
  end

  def self.search_match_title_false_elastic_search(query)  
    
    # Search all the specified fields 
    self.search(query).records

    # I tried to work with exact matching and tried these options as suggested by searchkick documentation but exact matching wasn't working. 
    # I have raised the issue and asked for help on their github. If given more time, I will be able to find it. 
    #I know in pure elasticsearch using term is the way.

    # self.search(query, fields: [{title: :word_middle}, {publisher_name: :word}, {last_name: :word}]).records    
    # self.search(query, fields: [:title, {publisher_name: :exact}, {last_name: :exact}]).records  
    # self.search(query, where: [{last_name: /\b"#{query}"\b/},{publisher_name: /\b"#{query}"\b/},{title: /\b"#{query}"\b/}]).records
  end

  #minimizing class dependecies by providing private methods as external interfaces

  private

  def get_book_format_types(book_id)
    BookFormat.get_book_format_types(book_id)   
  end

  def get_author_name(author_id)
    Author.get_author_name_from_id(author_id)
  end

  def get_average_rating(book_id)
    BookReview.get_average_rating_for_book(book_id)
  end

end
