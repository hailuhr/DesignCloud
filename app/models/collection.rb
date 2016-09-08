class Collection < ActiveRecord::Base

  has_many :images
  belongs_to :user


  def self.random_selection(user)
    if user
      (Collection.all - user.collections).sample(9)
    else
      Collection.all.sample(9)
    end
  end


  def owner?(user)
    self.user == user
  end


end
