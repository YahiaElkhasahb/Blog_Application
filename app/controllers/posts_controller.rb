class PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def index
    @posts = Post.all
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      PostDeletionWorker.perform_at(24.hours.from_now, @post.id)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :tags)
  end
end
