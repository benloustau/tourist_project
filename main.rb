require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'

set :database, "sqlite3:example.sqlite3"

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
	@user = User.where(email: params[:email]).first
 	if @user && @user.password  == params[:password] 
		session[:user_id] = @user.id
		redirect'/home'
  	else
  		flash[:alert] = "Sorry, that user doesn't exist. Feel free to sign up."
    	redirect '/index'
	end
end	

post '/sign_up' do
 User.create(params[:user])
 redirect '/home'
end	
	
