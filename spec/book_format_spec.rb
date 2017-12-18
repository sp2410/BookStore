require 'spec_helper'

describe BookFormat do	

    context "validates presence of both book-format_type id and book" do 

        it "should raise validation errors for empty first name or last name" do
            expect(build(:book_format, book_id: nil).valid?).to eq(false)
            expect(build(:book_format, book_format_type_id: nil).valid?).to eq(false)            
        end         
    end

    
     context "get_book_format_types" do 

        it "should get collection of book, name and physical if record exists" do

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
            create(:book_format, book_id: book3.id, book_format_type_id: book_format_type4.id)

            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type1.id)
            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type2.id)
            create(:book_format, book_id: book4.id, book_format_type_id: book_format_type3.id)            



            expect(BookFormat.get_book_format_types(book1.id)).to eq([{:name => "Hardcover", :physical => true},{:name => "Softcover", :physical => true}, {:name => "Kindle", :physical => false}, {:name => "Pdf", :physical => false}])            
            expect(BookFormat.get_book_format_types(book2.id)).to eq([{:name => "Hardcover", :physical => true}, {:name => "Kindle", :physical => false}, {:name => "Pdf", :physical => false}])            
            expect(BookFormat.get_book_format_types(book3.id)).to eq([{:name => "Hardcover", :physical => true},{:name => "Softcover", :physical => true}, {:name => "Pdf", :physical => false}])            
            expect(BookFormat.get_book_format_types(book4.id)).to eq([{:name => "Hardcover", :physical => true},{:name => "Softcover", :physical => true}, {:name => "Kindle", :physical => false}])            
        end

         it "should give users informations if record is not found" do            
            expect(BookFormat.get_book_format_types(11)).to eq([])            
        end
    end


    

end
