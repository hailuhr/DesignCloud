class Image < ActiveRecord::Base
  belongs_to :collection

  #has_many :tags
end
