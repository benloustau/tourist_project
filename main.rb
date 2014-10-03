require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require 'mandrill'

set :database, "sqlite3:example.sqlite3"

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

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

get '/profile' do
	erb :profile
end

get '/edit_profile' do
	erb :edit_profile
end

get '/contact_us' do
	erb :contact_us
end

post '/sign_in' do
	puts "params are: #{params.inspect}"
	@user = User.where(email: params[:user][:email]).first
 	if @user && @user.password  == params[:user][:password] 
 		flash[:notice] = "You have successfully signed in"
		session[:user_id] = @user.id
		redirect'/home'
  	else
  	flash[:notice] = "Login failed please try again or sign up"
    redirect '/'
	end
end	

post '/sign_up' do
	User.create(params[:user])
	flash[:notice] = "Your account has been created. Please login or sign-up"
 	redirect '/profile'

end	

get 'users/:id' do
	User.all.each do |id|

	end
end

post '/edit_profile' do
	puts "params are: #{params.inspect}"
	@profile = Profile.new(params[:profile])
	@profile.user = current_user
	@profile.save
	flash[:notice] = "Thank you for creating your profile."
	redirect '/profile'
end

post '/post_profile_tweet' do
	puts "params are: #{params.inspect}"
	@post = Post.new(params[:post])
	@post.user = current_user
	@post.save
	redirect '/profile'
end

get '/logout' do
	session[:user_id] = nil
	redirect '/'
end

post '/profile' do
	puts "params are: #{params.inspect}"
	@post = Post.new(params[:post])
	@post.user = current_user
	@post.save
	redirect '/profile'
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

delete '/user_id' do |id|
	 User.delete(params[:user]) 
	redirect '/'
 end




