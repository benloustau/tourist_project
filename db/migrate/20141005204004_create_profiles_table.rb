class CreateProfilesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do |t|
  		t.integer :user_id
  		t.string :bio
  		t.string :gender
  		t.date :birthday
  		t.boolean :resident
  		t.string :interests
  		t.string :links_url
  		t.string :profile_image_url
  	end
  end
end
