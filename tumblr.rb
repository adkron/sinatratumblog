require "rubygems"
require "sinatra"
require "active_record"

include ERB::Util

ActiveRecord::Base.establish_connection(
   :adapter  => "sqlite3",
   :database => "tumblr.sqlite3"
 )

class Migrate < ActiveRecord::Migration
	def self.up
		create_table :posts do |t|
			t.text :body
			t.string :title
		end
	end
	
	def self.down
		drop_table :posts
	end
end

class Post < ActiveRecord::Base
end

Migrate.up unless Post.table_exists?

get '/' do
	@posts = Post.find(:all)
	erb :index
end

post '/' do
		until Post.count(:all) < 5
			Post.delete(Post.find(:first))
		end
		@post = Post.new(:title => params[:title], :body => params[:body])
		@post.save
		redirect '/'
end