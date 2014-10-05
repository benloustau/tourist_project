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
	erb :home
end

post '/sign_in' do
	puts "params are: #{params.inspect}"
	@user = User.where(email: params[:user][:email]).first
 	if @user && @user.password  == params[:user][:password] 
 		session[:user_id] = @user.id
 		flash[:notice] = "You have successfully signed in"
 		if @user == params[:user_id]
 			redirect '/home'
 		else
			redirect '/profile/new'
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

get '/profile/new' do
	@profile = Profile.new
	erb :edit_profile
end

post '/edit_profile' do
	puts "params are: #{params.inspect}"
	@profile = Profile.new(params[:profile])
	@profile.user = current_user
	@profile.save
	flash[:notice] = "Thank you for creating your profile."
	redirect '/user/:id'
end

get '/user/:id' do
	if session[:user_id]
		@user = User.find(params[:id])
		redirect '/user/#{@user.id}'
    erb :profile
	else
		flash[:notice] = "You must log in to view this page."
		redirect '/'
	end
end

post '/post_profile_tweet' do
	puts "params are: #{params.inspect}"
	Post.order(created_at: :desc)
	@post = Post.new(params[:post])
	@post.user = current_user
	@post.save
	redirect '/profile'
end

post '/post_tweet' do
	puts "params are: #{params.inspect}"
	Post.order(created_at: :desc)
	@post = Post.new(params[:post])
	@post.user = current_user
	@post.save
	redirect '/home'
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

post '/followed' do
	@followed = User.take(params[:user_id])
	@followed.user = current_user.follows
	@followed.save
	redirect '/home'
end	

get '/logout' do
	flash[:notice] = "You have successfully been loged out"
	redirect '/'
	session.clear
end
	





