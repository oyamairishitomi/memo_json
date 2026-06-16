# frozen_string_literal: true

require 'sinatra'
require 'json'
enable :method_override

FILE_PATH = './memos.json' # 保存先

## 読み取り
def read_memos
  return [] unless File.exist?(FILE_PATH)

  JSON.parse(File.read(FILE_PATH), symbolize_names: true)
  ## RUBY配列化。ファイルを文字列として読む→[{id: 1, title: ".."}]
  ## symbolize- は文字列をシンボルにする
end

## 書き込み
def write_memos(memos)
  File.write(FILE_PATH, JSON.generate(memos))
end

## XSS
set :erb, escape_html: true

get '/memos' do
  @memos = read_memos
  # #read_memosの返り値が入る
  erb :index
end

get '/memos/new' do
  erb :new
end

def find_memo(memos, id)
  memos.find { |m| m[:id] == id.to_i }
end

post '/memos' do
  memos = read_memos
  new_memo = { id: (memos.map { |m| m[:id] }.max || 0) + 1 }.merge(params.slice(:title, :content))
  ## IDはメモIDの最大に＋１。変数を保持できないのでJSONから作る
  memos << new_memo
  write_memos(memos)
  redirect '/memos'
end

get '/memos/:id' do
  @memo = find_memo(read_memos, params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(read_memos, params[:id])
  erb :edit
end

patch '/memos/:id' do
  memos = read_memos
  memo = find_memo(memos, params[:id])
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  write_memos(memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = read_memos
  memos.reject! { |m| m[:id] == params[:id].to_i }
  write_memos(memos) # #消したあとの配列を上書き
  redirect '/memos'
end
