# frozen_string_literal: true

require 'pg'

DB = PG.connect(dbname: 'memo_app_development')

class Memo
  attr_accessor :id, :title, :content

  def initialize(id, title, content)
    self.id = id
    self.title = title
    self.content = content
  end

  def self.all
    DB.exec('SELECT id, title, content FROM memos ORDER BY id').map do |row|
      Memo.new(row['id'], row['title'], row['content'])
    end
  end

  def self.create(title:, content:)
    result = DB.exec_params(
      'INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING id',
      [title, content]
    )
    Memo.new(result[0]['id'], title, content)
  end

  def self.find(id)
    result = DB.exec_params(
      'SELECT id, title, content FROM memos WHERE id = $1 LIMIT 1', [id]
    )
    Memo.new(result[0]['id'], result[0]['title'], result[0]['content'])
  end

  def update(title:, content:)
    DB.exec_params(
      'UPDATE memos SET title = $1, content = $2 WHERE id = $3',
      [title, content, id]
    )
  end

  def destroy
    DB.exec_params(
      'DELETE FROM memos WHERE id = $1',
      [id]
    )
  end
end
