# frozen_string_literal: true
require 'nokogiri'
require 'reverse_markdown'

FILE_PATH = 'exported_file_path' # Path of the exported file
def main
  blog = File.read(FILE_PATH).gsub(/-----[\r\n|\n|\r]EXTENDED BODY:/, '<!-- more -->')
  articles = split_to_articles(blog)
  headers_and_bodies = split_to_headers_and_bodies(articles)

  headers_and_bodies.each do |header_and_body|
    header_and_body[:header] = convert_header(header_and_body[:header])
    header_and_body[:body] = ReverseMarkdown.convert header_and_body[:body]
  end

  create_md_file(headers_and_bodies)
end

def split_to_articles(blog)
  blog.split(/-----[\r\n|\n|\r]--------/)
end

def split_to_headers_and_bodies(articles)
  headers_and_bodies = []

  articles.each do |article|
    header_and_body = article.split(/-----[\r\n|\n|\r]BODY:/)
    headers_and_bodies.push(header: header_and_body[0], body: header_and_body[1]) unless header_and_body[0].nil? || header_and_body[1].nil?
  end

  headers_and_bodies
end

LAYOUT = 'post'
AUTHOR = 'your_name' # Please write your name.
TAGS = '[blog]'
COMMENTS = 'false'
def convert_header(header)
  title = header.match(/^TITLE:\s(.+?)[\r\n|\n|\r]/)[1]
  date_string = header.match(/^DATE:\s(.+?)[\r\n|\n|\r]/)[1]

  <<~HEADER
    layout: #{LAYOUT}\r
    title: #{title}\r
    date: #{date_string[6..9]}/#{date_string[0..1]}/#{date_string[3..4]}\r
    author: #{AUTHOR}\r
    tags: #{TAGS}\r
    comments: #{COMMENTS}\r
  HEADER
end

def convert_jyekll_format_from_date_string(date_string)
  tmp = date_string.slice(0, 10)
  "#{tmp[6..9]}-#{tmp[0..1]}-#{tmp[3..4]}"
end

def create_md_file(headers_and_bodies)
  headers_and_bodies.each do |header_and_body|
    date_string = header_and_body[:header].match(/^date:\s(.+?)[\r\n|\n|\r]/)[1]
    file_name = "#{date_string.gsub(/\//, '-')}-from-hatena-blog.md"

    content = "---\r#{header_and_body[:header]}---\r#{header_and_body[:body]}"
    file = File.new(file_name,"w")
    file.puts(content)
  end
end

main
