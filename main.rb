require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require 'mandrill'

set :database, "sqlite3:example.sqlite3"

get '/index' do
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
	@user = User.where(email: params[:email]).first
 	if @user && @user.password  == params[:password] 
		session[:user_id] = @user.id
		redirect'/home'
  	else
  		flash[:notice] = "Login failed please try again or sign up"
    	redirect '/index'
	end
end	

post '/sign_up' do
	 User.create(params[:user])
 	flash[:notice] = "Your account has been created. Please login or sign-up"
 	redirect '/index'
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
	redirect '/home'
end
	
