class Image < ActiveRecord::Base
  
  belongs_to :collection

  
  def generate_link(user)
    if user == self.collection.user
      "/images/#{self.id}"
    else
      "#{self.url}"
    end
  end

end