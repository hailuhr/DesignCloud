class Collection < ActiveRecord::Base

  has_many :images
  belongs_to :user

end


#images - similar to songs, would be a database of images
