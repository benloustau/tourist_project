# -------- Users ----------------
user_1 = User.create do |a|
  a.fname = "Keika"
  a.lname = "Jones"
  a.email = "keika.jones@gmail.com"
  a.password = "kjones543"
end

user_2 = User.create do |a|
  a.fname = "Ben"
  a.lname = "Loustau"
  a.email = "bnloustau@gmail.com"
  a.password = "Lossia12"
end

user_3 = User.create do |a|
  a.fname = "Sho"
  a.lname = "Shaikh"
  a.email = "shoshaikh7@gmail.com"
  a.password = "blah"
end

user_4 = User.create do |a|
  a.fname = "Jamie"
  a.lname = "Christian"
  a.email = "christian.jamie@gmail.com"
  a.password = "jchristian123"
end

user_5 = User.create do |a|
  a.fname = "Yonji"
  a.lname = "Kim"
  a.email = "yjcanvas@gmail.com"
  a.password = "yjkim543"
end

user_6 = User.create do |a|
  a.fname = "Yuka"
  a.lname = "Nagai"
  a.email = "yukanagai@gmail.com"
  a.password = "ynagai789"
end

user_7 = User.create do |a|
  a.fname = "Daniel"
  a.lname = "Heller"
  a.email = "dannyheller@gmail.com"
  a.password = "dannyh456"
end

user_8 = User.create do |a|
  a.fname = "Eva"
  a.lname = "Shih"
  a.email = "evashih@gmail.com"
  a.password = "evas000"
end

user_9 = User.create do |a|
  a.fname = "Gabrielle"
  a.lname = "Godino"
  a.email = "gabriellegodino@gmail.com"
  a.password = "gabbyg123"
end

user_10 = User.create do |a|
  a.fname = "Jeremy"
  a.lname = "Kitchens"
  a.email = "jeremykitchens@gmail.com"
  a.password = "jkitchens89"
end


User.find(1).follwed << User.find(2)

User.find(2).follwed << User.find(3)

User.find(2).follwed << User.find(1)

User.find(3).follwed << User.find(1)
User.find(4).follwed << User.find(1)

User.find(5).follwed << User.find(2)

User.find(5).follwed << User.find(4)

User.find(4).follwed << User.find(6)
User.find(6).follwed << User.find(2)

User.find(6).follwed << User.find(7)

User.find(7).follwed << User.find(8)

User.find(7).follwed << User.find(3)
User.find(3).follwed << User.find(8)

User.find(8).follwed << User.find(10)

User.find(10).follwed << User.find(9)

User.find(9).follwed << User.find(8)
User.find(10).follwed << User.find(7)

User.find(6).follwed << User.find(3)

User.find(5).follwed << User.find(10)

User.find(4).follwed << User.find(7)

User.find(1).followers << User.find(2)

User.find(2).followers << User.find(3)

User.find(2).followers << User.find(1)

User.find(3).followers << User.find(1)
User.find(4).followers << User.find(1)

User.find(5).followers << User.find(2)

User.find(5).followers<< User.find(4)

User.find(4).followers << User.find(6)
User.find(6).followers << User.find(2)

User.find(6).followers << User.find(7)

User.find(7).followers << User.find(8)

User.find(7).followers << User.find(3)
User.find(3).followers << User.find(8)

User.find(8).followers << User.find(10)

User.find(10).followers << User.find(9)

User.find(9).followers << User.find(8)
User.find(10).followers << User.find(7)

User.find(6).followers << User.find(3)

User.find(5).followers << User.find(10)

User.find(4).followers << User.find(7)

















