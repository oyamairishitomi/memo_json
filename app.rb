# frozen_string_literal: true

require 'sinatra'
require_relative 'database'

enable :method_override

set :erb, escape_html: true # XSS

get '/memos' do
  @memos = Memo.all # SELECT * FROM memos
  # DBからメモを全部取ってきて、
  # erbでも使えるように @memos に入れる
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  Memo.create(title: params[:title], content: params[:content])
  redirect '/memos'
end

get '/memos/:id' do # :idでIDを取得できる
  @memo = Memo.find(params[:id]) # 指定したIDのメモを1件取得
  erb :show
end

get '/memos/:id/edit' do
  @memo = Memo.find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  memo = Memo.find(params[:id])
  memo.update(title: params[:title], content: params[:content])
  ## UPDATE/titleに各パラムを入れる
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memo = Memo.find(params[:id])
  memo.destroy # #memoを削除
  redirect '/memos'
end
