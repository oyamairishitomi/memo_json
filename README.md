# メモアプリ

SinatraとPostgreSQLを使ったシンプルなメモアプリです。

## 動作確認環境

- Ruby 3.3.0で動作を確認しています。
- PostgreSQL 16で動作を確認しています。

## セットアップ

```bash
git clone https://github.com/oyamairishitomi/memo_json.git
cd memo_json
bundle install
```

bundleをインストールすることで必要な要素を追加することができます。

### データベースの準備

あらかじめPostgreSQLをインストール・起動しておいてください。以下のコマンドで、データベースとテーブルを作成します。

```bash
createdb memo_app_development
psql -d memo_app_development -f db/create_tables.sql
```

## 起動方法

```bash
bundle exec ruby app.rb
```

起動後、ブラウザで http://localhost:4567/memos を開いてください。

## 機能（各機能テスト済み）

- メモの一覧表示
- メモの新規作成
- メモの詳細表示
- メモの編集
- メモの削除
