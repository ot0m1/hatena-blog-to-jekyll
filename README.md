# hatena-blog-to-jekyll
はてなブログからエクスポートしたファイルを jekyll 用のマークダウンファイルに変換します。

# 使い方
- このリポジトリをローカルにクローン
```
git clone https://github.com/ot0m1/hatena-blog-to-jekyll.git
```

- bundle install
```
bundle install
```

- はてなブログからエクスポートしたファイルのパスをファイルの 5 行目に追加
```ruby
FILE_PATH = 'exported_file_path' # Path of the exported file
```

- 記事のメタデータは 34 行目以降を変更してください
```
LAYOUT = 'post'
AUTHOR = 'your_name' # Please write your name.
TAGS = '[blog]'
COMMENTS = 'false'
```

- ファイルを実行
```
ruby convert_jyekll_format.rb
```

- `git clone` したディレクトリに記事毎にマークダウンファイルが作成されます
