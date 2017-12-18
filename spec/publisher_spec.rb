require 'spec_helper'

describe Publisher do
	

    context "validates presence of both first and last names" do 

        it "should raise validation errors for empty first name or last name" do
            expect(build(:publisher, name: nil).valid?).to eq(false)                        
        end         
    end
    

    context "get_publisher_name_from_id" do 

        it "should get publisher name from given id if record exists" do
            publisher1 = create(:publisher)
            publisher2 = create(:publisher, name: "Prentice Hall")      
            expect(Publisher.get_publisher_name_from_id(1)).to eq("Addison Wesley Professional Ruby")                          
            expect(Publisher.get_publisher_name_from_id(2)).to eq("Prentice Hall")                        
        end

         it "should give users informations if record is not found" do            
            expect(Publisher.get_publisher_name_from_id(11)).to eq('Publisher Record Not Found')               
        end
    end
    

end
