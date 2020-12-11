class TagsController < ApplicationController
  def index
    puts "★★★★★★★★★★"
    puts "タグ：　#{params[:tag_name]}"
    puts "★★★★★★★★★★"
    render json: {tags: ["hoge", "fuga", "foo", "bar"]}
  end
end
