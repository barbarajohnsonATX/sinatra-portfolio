class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer  "user_id"
      t.integer  "movie_id"
      t.text     "review_content"
      t.string   "star_rating"
      t.datetime "created_at",  null: false
      t.datetime "updated_at",  null: false
    end 
  end
end
