class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string  "title"
      t.text    "plot"
      t.string  "actors"
      t.string  "released"
      t.string  "runtime"
      t.string  "genre"
      t.string  "imdbID"
      t.string  "rated"
      t.string  "poster_url"
    end
  end
end
