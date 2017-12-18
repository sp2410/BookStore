require 'spec_helper'

describe Author do	

    context "validates presence of both first and last names" do 

        it "should raise validation errors for empty first name or last name" do
            expect(build(:author, first_name: nil , last_name: "provided").valid?).to eq(false)
            expect(not_an_author2 = build(:author, first_name: "provided" , last_name: nil) .valid?).to eq(false)            
        end         
    end

    

    context "get_author_name_from_id" do 

        it "should get author name from given id if record exists" do
            author1 = create(:author)
            author2 = create(:author, first_name: "Alan", last_name: "donovan")     
            expect(Author.get_author_name_from_id(1)).to eq('Sandi Metz')                          
            expect(Author.get_author_name_from_id(2)).to eq('Alan Donovan')                        
        end

         it "should give users informations if record is not found" do            
            expect(Author.get_author_name_from_id(11)).to eq('Author Record Not Found')               
        end
    end
    

end
