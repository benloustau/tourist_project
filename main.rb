require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require 'mandrill'

set :database, "sqlite3:example.sqlite3"
set :sessions => true
enable :sessions
use Rack::Flash, :sweep => true

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	else
		nil
	end
end

get '/' do
	erb :index
end

get '/home' do
	@user = current_user
	erb :home
end

post '/sign_in' do
	puts "params are: #{params.inspect}"
	@user = User.where(email: params[:user][:email]).first
 	if @user && @user.password  == params[:user][:password] 
 		session[:user_id] = @user.id
 		flash[:notice] = "You have successfully signed in"
 		User.all.each do |id|
 			if @current_user == params[:user_id]
 				redirect '/home'
 			else
				redirect '/edit_profile'
			end
		end
  else
		flash[:notice] = "Login failed please try again or sign up"
    redirect '/'
	end
end	

post '/sign_up' do
	User.create(params[:user])
	flash[:notice] = "Your account has been created. Please login"
 	redirect '/'
end	

get '/profile' do
  	@user = current_user
	erb :profile
end

get '/profile/new' do
	@user = current_user
	@profile = Profile.new
	erb :edit_profile
end

get '/edit_profile' do
	@user = current_user
	erb :edit_profile
end
 
post '/edit_profile' do
	puts "params are: #{params.inspect}"
	@profile = Profile.new(params[:profile])
	@profile.user = current_user
	@profile.save
	flash[:notice] = "Thank you for creating your profile."
	redirect '/profile'
end

get '/users/:user_id' do
	@user = User.find(params[:user_id])
	erb :profile
end


def date(time)
   time.strftime("%b %d %Y, %I:%M:%S %p")
end	

# def post(post)
# 	post.order(:created_at).last(10)
# end	

post '/post_profile_tweet' do
	puts "params are: #{params.inspect}"
	@post = Post.new(params[:post])
	@post.user = current_user
	@post.save
	redirect '/profile'
end


post '/post_tweet' do
	puts "params are: #{params.inspect}"
	@post= Post.new(params[:post])
	@post.user = current_user
	@post.save 
	redirect '/home'
end

get '/update_profile' do
	@user = @current_user
	erb :update_profile
end

post '/update_profile' do
  puts "params are: #{params.inspect}"
  @user = @current_user
  # @user = User.update(params[:user])
  # @user = current_user
  # @user.save

  # @profile = Profile.update(params[:profile])
  # @profile.user = current_user
  # @profile.save
  @current_user.update_attributes(params[:user])

  @current_user.profile.update_attributes(params[:profile])

  flash[:notice] = 'Your updates have been saved!'
  redirect '/home'
end

def date(time)
   time.strftime("%b %d %Y, %I:%M:%S %p")
end

get '/contact_us' do
	erb :contact_us
end

post '/send_email' do

	m = Mandrill::API.new
	comment = "<html><body> #{params[:comment]} </body></html>"
	message = { 
	 :subject=> "Customer comment from NYCTourist", 
	 :from_name=>"Customer",
	 :text=> params[:comment],
	 :to=>[ 
	 { 
	 :email=> "benloustau@gmail.com", 
	 :name=> "NYCTourist" 
	 } 
	 ], 
	 :html=> comment,
	 :from_email=> params[:from], 
	} 
	sending = m.messages.send message
	puts sending
	flash[:notice] = "Your email was sent successfully"
	redirect '/home'
end

post '/user_id' do
	@user = User.destroy(current_user.id)
	@user.posts.each(&:destroy)
	flash[:alert] = "This action is irriversible. Your User has been deleted"
	redirect '/'
	session.clear
end	

get "/users/:id/follow" do
	user = User.find(params[:id])
	current_user.follow!(user) if user
	flash[:notice] = "You have a new friend"
	user.save
	redirect '/home'
end	

post "/users/:id/follow" do
	user = User.find(params[:id])
	current_user.follow!(user) if user
	flash[:notice] = "You have a new friend"
	redirect '/users/#{params[:user_id]}'
end	

# get "/users/:id/follow" do
# 	user = User.find(params[:id])
# 	current_user.follow!(user) if user
# 	flash[:notice] = "You have a new friend"
# 	redirect '/home'
# end	


# post '/followed' do
# 	@followed = User.take(params[:user_id])
# 	@followed.user = current_user.follows
# 	@followed.save
# 	redirect '/home'
# end	

# post '/follow' do
#   @current_user.follow(params[:user_id])
#   flash[:notice] = "You've got a new friend!"
#   redirect "/users/#{params[:user_id]}"
# end


get '/logout' do
	flash[:notice] = "You have successfully been loged out"
	redirect '/'
	session.clear
end
	





