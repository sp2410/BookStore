require 'spec_helper'

describe BookFormatType do


    context "validates presence of both name and physical attribute" do 

        it "should raise validation errors for empty first name or last name" do
            expect(build(:book_format_type, name: nil , physical: true).valid?).to eq(false)            
            # expect(not_an_BookFormatType2.valid?).to eq(false)
        end         
    end

    

    context "get_book_format_name_and_physical" do 

        it "should get book format name and if book is physical for a given id" do
            book_format_type1 = create(:book_format_type)
            book_format_type2 = create(:book_format_type, name: "Paperback", physical: true)     
            expect(BookFormatType.get_book_format_name_and_physical(1)).to eq({:name => 'Hardcover', :physical => true})                          
            expect(BookFormatType.get_book_format_name_and_physical(2)).to eq({:name => 'Paperback', :physical => true})                          
        end

         it "should give users informations if record is not found" do            
            expect(BookFormatType.get_book_format_name_and_physical(11)).to eq('Book Format Type Record Not Found')               
        end
    end

end
