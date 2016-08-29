class User < ActiveRecord::Base
  has_many :collections

  # ^^^image_posts columns/attributes -> tags, image - making an attribute a link to the image, the image itself

  # validates_presence_of :username, :email, :password

  has_secure_password

  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.find {|user| user.slug == slug}
  end

end
