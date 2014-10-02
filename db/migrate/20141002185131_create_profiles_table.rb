class CreateProfilesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do |t|
  		t.integer :user_id
  		t.string :gender
  		t.boolean :resident
  		t.date :birthday
  	end
  end
end
