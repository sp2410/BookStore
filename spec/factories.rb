FactoryBot.define do

  factory :author do  	
    first_name "Sandi"
    last_name  "Metz"    
  end

  factory :publisher do  	
    name "Addison wesley professional ruby"    
  end

  factory :book_format_type do  	
     name "Hardcover"
     physical true    
  end

	factory :book do
		  association :author
		  association :publisher

		  title 'Practical Object Oriented Design In Ruby'
		  after(:create) do |part|
		    author = FactoryBot.create(:author)
		    publisher = FactoryBot.create(:publisher)
		    author_id = author.id
		    publisher_id = publisher.id
		end

	end


  factory :book_review do  	
     rating 1
     association :book

     after(:create) do |part|
     	book = FactoryBot.create(:book)
     	book_id = book.id
	   end

  end

  factory :book_format do  

      association :book
      association :book_format_type

     after(:create) do |part|
     	book = FactoryBot.create(:book)
     	book_format_type = FactoryBot.create(:book_format_type)

     	book_id = book.id
     	book_format_type_id = book_format_type.id
	   end

  end

  




end