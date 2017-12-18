class Purchase < ApplicationRecord
  belongs_to :customer
  belongs_to :book

  #class not implemented fully but I felt there would be a need afterwards.
end
