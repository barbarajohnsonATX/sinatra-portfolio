 
class User < ActiveRecord::Base
 
  # validates :username, :email, :password, presence: true
  # validates :email, uniqueness: true 

  has_secure_password
  has_many :reviews
  has_many :movies, through: :reviews

  def self.invalid?(params)
    #invalid if name or email already exists
    true if User.find_by(username: params[:username]) || User.find_by(email: params[:email])
  end 

  def slug
    #replace spaces with -
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.find{ |object| object.slug == slug}
  end

end
