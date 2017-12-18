require 'spec_helper'

describe BookReview do	

    context "validates presence of both rating and book_id" do 

        it "should raise validation errors for empty rating or book_id" do
            expect(build(:book_review, rating: nil ).valid?).to eq(false)
            expect(build(:book_review, book_id: nil ).valid?).to eq(false)            
        end         
    end

    

    context "get_average_rating_for_book" do 

        it "should get average rating for book if record exists" do
            book1 = create(:book)
                    create(:book_review, rating: 1, book_id: book1.id )
                    create(:book_review, rating: 2, book_id: book1.id )
                    create(:book_review, rating: 3, book_id: book1.id )
                    create(:book_review, rating: 4, book_id: book1.id )
                    create(:book_review, rating: 5, book_id: book1.id )
                    create(:book_review, rating: 6, book_id: book1.id )
                    create(:book_review, rating: 7, book_id: book1.id )
                    create(:book_review, rating: 8, book_id: book1.id )
            expect(BookReview.get_average_rating_for_book(book1.id)).to eq(4.5)                          



            author1 = create(:author, first_name: "Kate", last_name: "White")       
            publisher1 = create(:publisher, name: "HarperCollins")
            book2 = create(:book, title: "The Secrets You Keep: A Novel", author_id: author1.id, publisher_id: publisher1.id)
                    create(:book_review, rating: 1, book_id: book2.id )
                    create(:book_review, rating: 1, book_id: book2.id )
                    create(:book_review, rating: 1, book_id: book2.id )
                    create(:book_review, rating: 1, book_id: book2.id )
                    create(:book_review, rating: 1, book_id: book2.id )                   
            expect(BookReview.get_average_rating_for_book(book2.id)).to eq(1.0)              

        end

         it "should give users informations if record is not found" do            
            author3 = create(:author, first_name: "A. S. A.", last_name: "Harrison")       
            publisher3 = create(:publisher, name: "Penguin")
            book3 = create(:book, title: "The Silent Wife", author_id: author3.id, publisher_id: publisher3.id)
            expect(BookReview.get_average_rating_for_book(book3.id)).to eq("No Reviews Yet!") 
        end
    end
    

end
