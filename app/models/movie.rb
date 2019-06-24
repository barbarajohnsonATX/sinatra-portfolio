class Movie < ActiveRecord::Base
   

    has_many :reviews 

    def slug
        #replace spaces with -
        title.downcase.gsub(" ", "-")
    end
    
    def self.find_by_slug(slug)
        Movie.all.find{ |object| object.slug == slug}
    end

end
  