class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.integer :user_id
  		t.string :title
  		t.string :body
  		t.datetime :created_at
  		validates :title, presence: true, length: { minimum: 3 }
  		validates :body, presence: true, length: { maximum: 150}
  	end
  end
end
