class MovieController < ApplicationController

  get '/search' do 
         redirect 'movies/search'
  end

  get '/movies/search' do 
    erb :'movies/search'
  end 

  post '/movies' do 
    # params cannot be empty
    if params["title"].empty?
      flash[:message] = "Error: Search field must be filled."
      redirect to '/movies/search'
    end

    title = params[:title]
    url = "http://www.omdbapi.com/?s=#{title}&plot=full&apikey=cc4fb477"
    
    results = JSON.load(open(url).read)
    @movies = results["Search"]
    erb :'movies/results'
  end 

  
    post '/movies/results' do 

    if !logged_in?(session)
      flash[:message] = "You must be logged in to review a movie."
      redirect '/'
    end 

    @movie = get_movie_detail(params[:imdbID])
 
      found_movie = Movie.all.find{|i| i.imdbID == params[:imdbID]} 
      current_user =  current_user(session)

    if !found_movie || !current_user.movies.include?(found_movie)
      @new_movie = Movie.find_or_create_by(imdbID: params[:imdbID])
      @new_movie.title = @movie["Title"]
      @new_movie.plot = @movie["Plot"]
      @new_movie.actors = @movie["Actors"]
      @new_movie.released = @movie["Released"]
      @new_movie.runtime = @movie["Runtime"]
      @new_movie.genre = @movie["Genre"]
      @new_movie.rated = @movie["Rated"]
      @new_movie.poster_url = @movie["Poster"]
      @new_movie.save 
      current_user.movies << @new_movie
     else 
      flash[:message] = "You have already reviewed this movie."
      redirect '/movies/search'
    end 
    erb :'reviews/new'
 
end 
  
#read movie details via OMDB 
get '/movies/imdb/:movieID' do 
    imdbID = params[:movieID]
    @details = get_movie_detail(imdbID)
    erb :'movies/details'
end 
  
get '/movies/:slug' do 
    @movie = Movie.find_by_slug(params[:slug])
   erb :'movies/show'
end 
 

def  get_movie_detail(id)
  url = "http://www.omdbapi.com/?i=#{id}&plot=full&apikey=cc4fb477"
  results = JSON.load(open(url).read)
end 


 

  
end 
