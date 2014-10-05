class CreateRelationshipsTable < ActiveRecord::Migration
  def change
  	create_table :relationships do |t|
  		t.integer :follower_id
  		t.integer :follwed_id
  	end
  end
end
