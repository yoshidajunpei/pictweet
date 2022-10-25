class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    # @tweets = Tweet.includes(:user)
    query = "SELECT * FROM tweets"
    # @tweets = Tweet.find_by_sql(query)
    @tweets = Tweet.all
    @tweets = Tweet.includes(:user).order("created_at DESC")
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)
    #バリデーションに引っかからず保存されれば、「投稿完了」の画面が呼び出される
    if @tweet.save
    else
      #バリデーションに引っかかり保存されなければ、「新規投稿」の画面を呼び出す
      render 'new'
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
  end

  def edit
  end

  def update
    @tweet = Tweet.find(params[:id])
    #バリデーションに引っかからず更新されれば、「更新完了」の画面が呼び出される
    if @tweet.update(tweet_params)
    else
      #バリデーションに引っかかり保存されなければ、「編集」の画面が呼び出される
      render 'edit'
    end
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  def search
   @tweets = SearchTweetsService.search(params[:keyword])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end
