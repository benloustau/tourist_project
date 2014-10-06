class User < ActiveRecord::Base
	has_one :profile
	has_many :posts, dependent: :destroy
	has_many :relationships, foreign_key: :follower_id, dependent: :destroy #if I destroy one of the members then destroy this relationship as well
	has_many :reverse_relationships, foreign_key: :follwed_id, class_name: "Relationship"
	has_many :followers, through: :relationships
	has_many :follwed, through: :relationships, source: :follwed

	def full_name
		if !fname.nil? && !lname.nil?
			fname + " " + lname
		elsif !fname.nil?
			fname
		elsif !lname.nil?
			lname
		end
	end

	def follow!(user)
		follwed << user
	end	
	
end 

class Profile <ActiveRecord::Base
	belongs_to :user 
end

class Post <ActiveRecord::Base
	belongs_to :user
	validates :title, presence: true, length: { minimum: 2 }
 	validates :body, presence: true, length: { maximum: 150 }
end

class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
	belongs_to :follwed, class_name: "User"
	validates_uniqueness_of :follower_id, scope: :follwed_id
end