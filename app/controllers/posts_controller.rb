class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  helper_method :page

  def index
    # TODO: implement WebHooks so that we don't need to pull here
    page.pull
    page.save

    @posts = page.posts.order(created_at: :desc)
  end

  def new
    @post = page.posts.new
    @post.preset = :short
  end

  def show
  end

  def edit
  end

  def create
    @post = page.posts.new(post_params)
    if @post.save
      @post.push
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      @post.push
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
  end

  private

  def page
    @page ||= Page.find(params[:page_id]) if params[:page_id]
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:message, :preset)
  end
end
