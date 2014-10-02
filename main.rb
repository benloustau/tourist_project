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