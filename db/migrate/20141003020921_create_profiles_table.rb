class CreateProfilesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do |t|
  		t.integer :user_id
  		t.string :bio
  		t.string :gender
  		t.date :birthday
  		t.boolean :resident
  	end
  end
end
