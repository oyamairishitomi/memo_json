# frozen_string_literal: true

require 'sinatra'
require_relative 'database'

enable :method_override

set :erb, escape_html: true # XSS

get '/memos' do
  @memos = Memo.all
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  Memo.create(title: params[:title], content: params[:content])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = Memo.find(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = Memo.find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  memo = Memo.find(params[:id])
  memo.update(title: params[:title], content: params[:content])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memo = Memo.find(params[:id])
  memo.destroy
  redirect '/memos'
end
