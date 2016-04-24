class PostsController < ApplicationController
  before_action :set_posts, only: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @post = Post.new
  end

  def show
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    if @post.save
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
    else
    end
  end

  def destroy
    @post.destroy
  end

  private

  def set_posts
    @posts = Post.order(id: :desc)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:message)
  end
end
