require 'spec_helper'

describe Book do
	

    context "validates presence of title, author and publisher" do 
        it "should raise validation errors for empty fields" do
            expect(build(:book, title: nil).valid?).to eq(false)            
            expect(build(:book, author_id: nil).valid?).to eq(false)  
            expect(build(:book, publisher_id: nil).valid?).to eq(false) 
        end         
    end


     context "book_format_types" do 

        it "should get an array of book format name and physical for the book if available" do            
            book1 = create(:book)

            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")
            book2 = create(:book, title: "The Secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)


            publisher3 = create(:publisher, name: "Pamela Dorman Books;")
            author3 = create(:author, first_name: "Shari", last_name: "Lapena")  
            book3 = create(:book, title: "Couple Next Door", author_id: author3.id, publisher_id: publisher3.id)

            author4 = create(:author, first_name: "Lauren", last_name: "Graham")       
            publisher4 = create(:publisher, name: "Ballantine Books")
            book4 = create(:book, title: "Someday, Someday, Maybe", author_id: author3.id, publisher_id: publisher3.id)
            
            
            book_format_type1 = create(:book_format_type, name: "Hardcover", physical: true)     
            book_format_type2 = create(:book_format_type, name: "Softcover", physical: true)     
            book_format_type3 = create(:book_format_type, name: "Kindle", physical: false)     
            book_format_type4 = create(:book_format_type, name: "PDF", physical: false)

            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type2.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type3.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book2.id, book_format_type_id: book_format_type1.id)            
            create(:book_format, book_id: book2.id, book_format_type_id: book_format_type3.id)
            create(:book_format, book_id: book2.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type2.id)                        

            expect(book1.book_format_types).to eq([{:name => "Hardcover", :physical => true},{:name => "Softcover", :physical => true}, {:name => "Kindle", :physical => false}, {:name => "Pdf", :physical => false}]) 
            expect(book2.book_format_types).to eq([{:name => "Hardcover", :physical => true}, {:name => "Kindle", :physical => false}, {:name => "Pdf", :physical => false}]) 
            expect(book3.book_format_types).to eq([{:name => "Hardcover", :physical => true},{:name => "Softcover", :physical => true}]) 
            expect(book4.book_format_types).to eq([]) 

            
        end        
    end

    

    context "author_name" do 

        it "should get author name from given id if record exists" do            
            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")

            book1 = create(:book, title: "The Secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)

            expect(book1.author_name).to eq('Kate White')                                                          
        end

         it "should give users information if record is not found" do 
            
            publisher1 = create(:publisher, name: "HarperCollins")
            author1 = create(:author, first_name: "Kate", last_name: "White")  

            book2 = create(:book, title: "The Secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)

            Author.destroy(author1.id)

            expect(book2.author_name).to eq('Author Record Not Found')               
        end
    end
    


     context "average_rating" do 

        it "should get average_rating from given id if record exists" do            
            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")

            book1 = create(:book, title: "The Secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)
                create(:book_review, rating: 1, book_id: book1.id )
                create(:book_review, rating: 2, book_id: book1.id )
                create(:book_review, rating: 3, book_id: book1.id )
                create(:book_review, rating: 4, book_id: book1.id )
                create(:book_review, rating: 5, book_id: book1.id )
                create(:book_review, rating: 6, book_id: book1.id )
                create(:book_review, rating: 7, book_id: book1.id )
                create(:book_review, rating: 8, book_id: book1.id )

            expect(BookReview.get_average_rating_for_book(book1.id)).to eq(4.5)                                                                                    
        end

        it "should give users information if record is not found" do 
            
            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")

            book1 = create(:book, title: "The Secrets You Keep: A Novel Paperback", author_id: author1.id, publisher_id: publisher1.id)                

            expect(BookReview.get_average_rating_for_book(book1.id)).to eq("No Reviews Yet!") 
        end
    end


     context "search" do 

        it "should search for books for given query and default options" do            

            book0 = create(:book)            

            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")
            book1 = create(:book, title: "The Secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)

            publisher3 = create(:publisher, name: "Pamela Dorman Books;")
            author3 = create(:author, first_name: "Shari", last_name: "Lapena")  
            book3 = create(:book, title: "Couple Next Door", author_id: author3.id, publisher_id: publisher3.id)


            author4 = create(:author, first_name: "Lauren", last_name: "Graham")       
            publisher4 = create(:publisher, name: "Ballantine Books")
            book4 = create(:book, title: "Someday, Secrets Someday, Maybe", author_id: author4.id, publisher_id: publisher4.id)

            #Matches  book name and author last name
            author5 = create(:author, first_name: "Fictious", last_name: "Fictious")       
            publisher5 = create(:publisher, name: "Ballantine Books")
            book5 = create(:book, title: "Fictious Book 1", author_id: author5.id, publisher_id: publisher5.id)

            #Matches  book name and author last name
            author6 = create(:author, first_name: "Lauren", last_name: "Fictious")       
            publisher6 = create(:publisher, name: "Ballantine Books")
            book6 = create(:book, title: "Fictious Book 2", author_id: author6.id, publisher_id: publisher6.id)

            #Matches  book name and publisher name
            author7 = create(:author, first_name: "Fictious", last_name: "Graham")       
            publisher7 = create(:publisher, name: "Fictious")
            book7 = create(:book, title: "Fictious Book 3", author_id: author7.id, publisher_id: publisher7.id)

            #Matches author last name, book name and publisher name
            author8 = create(:author, first_name: "Lauren", last_name: "Fictious")       
            publisher8 = create(:publisher, name: "Fictious")
            book8 = create(:book, title: "Fictious Book 4", author_id: author8.id, publisher_id: publisher8.id)

            #Matches only publisher name
            author9 = create(:author, first_name: "Lauren", last_name: "Picaso")       
            publisher9 = create(:publisher, name: "Fictious")
            book9 = create(:book, title: "Cool Book", author_id: author9.id, publisher_id: publisher9.id)

            expect(Book.sql_search('The Secrets You Keep: A Novel')).to match_array([book1]) 
            expect(Book.sql_search('Secrets')).to match_array([book1, book4])
            expect(Book.sql_search('Fictious')).to match_array([book5, book6, book7, book8, book9])

        end

        it "should search for books for given query and given title only option" do

            book0 = create(:book)            

            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")
            book1 = create(:book, title: "The Secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)

            publisher3 = create(:publisher, name: "Pamela Dorman Books;")
            author3 = create(:author, first_name: "Shari", last_name: "Lapena")  
            book3 = create(:book, title: "Couple Next Door", author_id: author3.id, publisher_id: publisher3.id)


            author4 = create(:author, first_name: "Lauren", last_name: "Graham")       
            publisher4 = create(:publisher, name: "Ballantine Books")
            book4 = create(:book, title: "Someday, Secrets Someday, Maybe", author_id: author4.id, publisher_id: publisher4.id)

            #Matches  book name and author last name
            author5 = create(:author, first_name: "Fictious", last_name: "Fictious")       
            publisher5 = create(:publisher, name: "Ballantine Books")
            book5 = create(:book, title: "Fictious Book 1", author_id: author5.id, publisher_id: publisher5.id)

            #Matches  book name and author last name
            author6 = create(:author, first_name: "Lauren", last_name: "Fictious")       
            publisher6 = create(:publisher, name: "Ballantine Books")
            book6 = create(:book, title: "Book 2", author_id: author6.id, publisher_id: publisher6.id)

            #Matches  book name and publisher name
            author7 = create(:author, first_name: "Fictious", last_name: "Graham")       
            publisher7 = create(:publisher, name: "Fictious")
            book7 = create(:book, title: "Book 3", author_id: author7.id, publisher_id: publisher7.id)

            #Matches author last name, book name and publisher name
            author8 = create(:author, first_name: "Lauren", last_name: "Fictious")       
            publisher8 = create(:publisher, name: "Fictious")
            book8 = create(:book, title: "Fictious Book 4", author_id: author8.id, publisher_id: publisher8.id)

            #Matches only publisher name
            author9 = create(:author, first_name: "Lauren", last_name: "Picaso")       
            publisher9 = create(:publisher, name: "Fictious")
            book9 = create(:book, title: "Cool Book", author_id: author9.id, publisher_id: publisher9.id)

            expect(Book.sql_search('The Secrets You Keep: A Novel', title_only: true)).to match_array([book1]) 
            expect(Book.sql_search('Secrets', title_only: true)).to match_array([book1, book4])
            expect(Book.sql_search('Fictious',title_only: true)).to match_array([book5, book8])

        end

        it "should search for books for given query and given title only option" do

            book0 = create(:book)            

            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")
            book1 = create(:book, title: "The Secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)

            publisher3 = create(:publisher, name: "Pamela Dorman Books;")
            author3 = create(:author, first_name: "Shari", last_name: "Lapena")  
            book3 = create(:book, title: "Couple Next Door", author_id: author3.id, publisher_id: publisher3.id)


            author4 = create(:author, first_name: "Lauren", last_name: "Graham")       
            publisher4 = create(:publisher, name: "Ballantine Books")
            book4 = create(:book, title: "Someday, Secrets Someday, Maybe", author_id: author4.id, publisher_id: publisher4.id)

            #Matches  book name and author last name
            author5 = create(:author, first_name: "Fictious", last_name: "Secrets")       
            publisher5 = create(:publisher, name: "Ballantine Books")
            book5 = create(:book, title: "Fictious Book 1", author_id: author5.id, publisher_id: publisher5.id)

            #Matches  book name and author last name
            author6 = create(:author, first_name: "Lauren", last_name: "Fictious")       
            publisher6 = create(:publisher, name: "Ballantine Books")
            book6 = create(:book, title: "Book 2", author_id: author6.id, publisher_id: publisher6.id)

            #Matches  book name and publisher name
            author7 = create(:author, first_name: "Fictious", last_name: "Graham")       
            publisher7 = create(:publisher, name: "Fictious")
            book7 = create(:book, title: "Book 3", author_id: author7.id, publisher_id: publisher7.id)

            #Matches author last name, book name and publisher name
            author8 = create(:author, first_name: "Lauren", last_name: "Fictious")       
            publisher8 = create(:publisher, name: "Fictious")
            book8 = create(:book, title: "Fictious Book 4", author_id: author8.id, publisher_id: publisher8.id)

            #Matches only publisher name
            author9 = create(:author, first_name: "Lauren", last_name: "Secrets")       
            publisher9 = create(:publisher, name: "Secrets")
            book9 = create(:book, title: "Cool Book", author_id: author9.id, publisher_id: publisher9.id)


            book_format_type1 = create(:book_format_type, name: "Hardcover", physical: true)     
            book_format_type2 = create(:book_format_type, name: "Softcover", physical: true)     
            book_format_type3 = create(:book_format_type, name: "Kindle", physical: false)     
            book_format_type4 = create(:book_format_type, name: "PDF", physical: false)

            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type2.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type3.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type1.id)            
            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type3.id)
            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type2.id)            
            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book5.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book5.id, book_format_type_id: book_format_type2.id)
            create(:book_format, book_id: book5.id, book_format_type_id: book_format_type3.id)  


                create(:book_review, rating: 5, book_id: book1.id )                

                create(:book_review, rating: 1, book_id: book3.id )
                create(:book_review, rating: 1, book_id: book3.id )
                create(:book_review, rating: 1, book_id: book3.id )
                create(:book_review, rating: 1, book_id: book3.id )
                create(:book_review, rating: 1, book_id: book3.id )
                

                create(:book_review, rating: 5, book_id: book4.id )
                create(:book_review, rating: 5, book_id: book4.id )
                create(:book_review, rating: 5, book_id: book4.id )
                create(:book_review, rating: 5, book_id: book4.id )                
                create(:book_review, rating: 5, book_id: book4.id )


                create(:book_review, rating: 5, book_id: book5.id )
                create(:book_review, rating: 3, book_id: book5.id )
                create(:book_review, rating: 3, book_id: book5.id )
                create(:book_review, rating: 3, book_id: book5.id )
                create(:book_review, rating: 5, book_id: book5.id )
                


            #test title only, where book format is hardcover    

            expect(Book.sql_search('The Secrets You Keep: A Novel', title_only: true, book_format_type_id: book_format_type1.id)).to match_array([book1])


            #test title only, where book format is hardcover
            expect(Book.sql_search('Secrets', title_only: true, book_format_type_id: book_format_type1.id)).to match_array([book1, book4])

            #test title only false, where book format is hardcover
            expect(Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type1.id)).to match_array([book1, book4, book5])
            

            #test title only false, where book format is kindle
            expect(Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type3.id)).to match_array([book1, book5])

            #test title only false, where book format is hardcover

            # p Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type1.id, book_format_physical: false)

            expect(Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type1.id, book_format_physical: false)).to match_array([])

            expect(Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type3.id, book_format_physical: false)).to match_array([book1, book5])
            
            expect(Book.sql_search('Secrets', title_only: false, book_format_physical: false)).to match_array([book1,book4,book5])

            expect(Book.sql_search('Secrets', title_only: true, book_format_physical: false)).to match_array([book1, book4])

            expect(Book.sql_search('Secrets', book_format_physical: false)).to match_array([book1,book4,book5])
            
            expect(Book.sql_search('', book_format_physical: false)).to match_array([book1,book4,book5, book3])

        end













    # Elastic Search tests:

        it "should search for books for given query and given title only options" do
            Book.searchkick_index.delete

            book0 = create(:book)       


            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")
            book1 = create(:book, title: "secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)

            publisher3 = create(:publisher, name: "Pamela Dorman Books;")
            author3 = create(:author, first_name: "Shari", last_name: "Lapena")  
            book3 = create(:book, title: "Couple Next Door", author_id: author3.id, publisher_id: publisher3.id)


            author4 = create(:author, first_name: "Lauren", last_name: "Graham")       
            publisher4 = create(:publisher, name: "Ballantine Books")
            book4 = create(:book, title: "Someday, Secrets Someday, Maybe", author_id: author4.id, publisher_id: publisher4.id)

            #Matches  book name and author last name
            author5 = create(:author, first_name: "Fictious", last_name: "Secrets")       
            publisher5 = create(:publisher, name: "Ballantine Books")
            book5 = create(:book, title: "Fictious Book 1", author_id: author5.id, publisher_id: publisher5.id)

            #Matches  book name and author last name
            author6 = create(:author, first_name: "Lauren", last_name: "Fictious")       
            publisher6 = create(:publisher, name: "Ballantine Books")
            book6 = create(:book, title: "Book 2", author_id: author6.id, publisher_id: publisher6.id)

            #Matches  book name and publisher name
            author7 = create(:author, first_name: "Fictious", last_name: "Graham")       
            publisher7 = create(:publisher, name: "Fictious")
            book7 = create(:book, title: "Book 3", author_id: author7.id, publisher_id: publisher7.id)

            #Matches author last name, book name and publisher name
            author8 = create(:author, first_name: "Lauren", last_name: "Fictious")       
            publisher8 = create(:publisher, name: "Fictious")
            book8 = create(:book, title: "Fictious Book 4", author_id: author8.id, publisher_id: publisher8.id)

            #Matches only publisher name
            author9 = create(:author, first_name: "Lauren", last_name: "xyz")       
            publisher9 = create(:publisher, name: "Secrets")
            book9 = create(:book, title: "Cool Book", author_id: author9.id, publisher_id: publisher9.id)


            book_format_type1 = create(:book_format_type, name: "Hardcover", physical: true)     
            book_format_type2 = create(:book_format_type, name: "Softcover", physical: true)     
            book_format_type3 = create(:book_format_type, name: "Kindle", physical: false)     
            book_format_type4 = create(:book_format_type, name: "PDF", physical: false)

            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type2.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type3.id)
            create(:book_format, book_id: book1.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type1.id)            
            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type3.id)
            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type2.id)            
            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book5.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book5.id, book_format_type_id: book_format_type2.id)
            create(:book_format, book_id: book5.id, book_format_type_id: book_format_type3.id)  


                create(:book_review, rating: 5, book_id: book1.id )
                # create(:book_review, rating: 5, book_id: book1.id )
                # create(:book_review, rating: 5, book_id: book1.id )
                # create(:book_review, rating: 5, book_id: book1.id )
                # create(:book_review, rating: 5, book_id: book1.id )
                # create(:book_review, rating: 5, book_id: book1.id )                            

                create(:book_review, rating: 1, book_id: book3.id )
                create(:book_review, rating: 1, book_id: book3.id )
                create(:book_review, rating: 1, book_id: book3.id )
                create(:book_review, rating: 1, book_id: book3.id )
                create(:book_review, rating: 1, book_id: book3.id )
                

                create(:book_review, rating: 5, book_id: book4.id )
                create(:book_review, rating: 5, book_id: book4.id )
                create(:book_review, rating: 5, book_id: book4.id )
                create(:book_review, rating: 5, book_id: book4.id )                
                create(:book_review, rating: 5, book_id: book4.id )


                create(:book_review, rating: 5, book_id: book5.id )
                create(:book_review, rating: 3, book_id: book5.id )
                create(:book_review, rating: 3, book_id: book5.id )
                create(:book_review, rating: 3, book_id: book5.id )
                create(:book_review, rating: 5, book_id: book5.id )
                


            #test title only, where book format is hardcover  

            # Book.reindex  
            
            # Book.reindex
            # Book.searchkick_index.refresh
            # p Book.search "Secrets"
            # p Book.search_instead_with_elastic_search("Secrets")

            Book.reindex
            Book.searchkick_index.refresh

            expect(Book.search_instead_with_elastic_search('Secrets')).to match_array([book1, book4, book5, book9])
            # p Book.search_instead_with_elastic_search('Secrets')


            # #test title only, where book format is hardcover
            expect(Book.search_instead_with_elastic_search('Secrets', title_only: true, book_format_type_id: book_format_type1.id)).to match_array([book1, book4])

            # #test title only false, where book format is hardcover
            expect(Book.search_instead_with_elastic_search('Secrets', title_only: false, book_format_type_id: book_format_type1.id)).to match_array([book1, book4, book5])
            

            # #test title only false, where book format is kindle
            expect(Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type3.id)).to match_array([book1, book5])

            # #test title only false, where book format is hardcover

            # # p Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type1.id, book_format_physical: false)

            expect(Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type1.id, book_format_physical: false)).to match_array([])

            expect(Book.sql_search('Secrets', title_only: false, book_format_type_id: book_format_type3.id, book_format_physical: false)).to match_array([book1, book5])
            
            expect(Book.sql_search('Secrets', title_only: false, book_format_physical: false)).to match_array([book1,book4,book5])

            expect(Book.sql_search('Secrets', title_only: true, book_format_physical: false)).to match_array([book1, book4])

            expect(Book.sql_search('Secrets', book_format_physical: false)).to match_array([book1,book4,book5])
            
            expect(Book.sql_search('', book_format_physical: false)).to match_array([book1,book4,book5, book3])

        end
        
    end

end
