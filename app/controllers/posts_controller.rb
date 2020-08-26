class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index 
    render json: Post.all
  end

  def show
    post = Post.find!(params[:id])
  end

  def create
    post = Post.create(post_params.merge(user: current_user))
    if post.persisted?
      render json: post, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  def update
    post = Post.find(params[:id])

    if post.user != current_user
      head :forbidden
    elsif post.update(post_params)
      render json: post, status: :ok
    else
      render json: post.errors, status: unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])

    if post.user != current_user
      head :forbidden
    else
      post.destroy
      head :ok
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :title)
  end
end
