class TagsController < ApplicationController
  def index
    puts "★★★★★★★★★★"
    puts "タグ：　#{params[:tag_name]}"
    puts "★★★★★★★★★★"
    return render json: {tags: [] } if params[:tag_name] == ""  ## ""で検索にかけると全てヒットしてしまうため""の場合はここで終了
    tags = Tag.where(['name LIKE ?', "%#{params[:tag_name]}%"] )
    render json: {tags: tags}
  end
end
