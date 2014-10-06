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
	@user = @current_user
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
	session[:user_id] = user.id
	flash[:notice] = "Your account has been created. Please login"
 	redirect '/'
end	

get '/profile' do
  	@user = @current_user
	erb :profile
end

get '/profile/new' do
	@user = @current_user
	@profile = Profile.new
	erb :edit_profile
end

get '/edit_profile' do
	@user = @current_user
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

get '/user/:user_id' do
	@user = User.find(params[:user_id])
	erb :profile
end

post '/post_profile_tweet' do
	puts "params are: #{params.inspect}"
	@post = Post.new(params[:post])
	@post.user = current_user
	@post.save
	redirect '/profile'
end


post '/post_tweet' do
	puts "params are: #{params.inspect}"
	@post = Post.new(params[:post])
	@post.user = current_user
	@post.length(10)
	@post.save
	redirect '/home'
end

get "/home" do
  @posts = Post.order("created_at DESC")
  erb :home
end

post '/update' do
  @current_user.update_attributes(
    fname: params[:user][:fname],
    lname: params[:user][:lname],
    email: params[:user][:email],
    password: params[:user][:password],
  )

  @current_user.profile.update_attributes(
    profile_image_url: params[:profile][:profile_image_url]
  )
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

post '/follow' do
  @current_user.follow(params[:user_id])
  flash[:notice] = "You've got a new friend!"
  redirect "/users/#{params[:user_id]}"
end

get '/logout' do
	flash[:notice] = "You have successfully been loged out"
	redirect '/'
	session.clear
end
	





