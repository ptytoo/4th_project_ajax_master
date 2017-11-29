class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :create_comment, :like_post]
  before_action :is_login?, only: [:create_comment, :like_post, :destroy_comment]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order("updated_at DESC").page(params[:page])
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @like = true
    if user_signed_in?
      @like = current_user.likes.find_by(post_id: @post.id).nil?
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_comment
    @c = @post.comments.create(comment_params)
  end

  def like_post
    if Like.where(user_id: current_user.id, post_id: @post.id).first.nil? #좋야요 안눌렀었다면...
      #좋아요를 만들어주면 된다.
      @result = current_user.likes.create(post_id: @post.id)
      # puts '좋아요!'
    else #현재 유저가 좋아요를 누른경우
      #기존의 좋아요 삭제
      @result = current_user.likes.find_by(post_id: @post.id).destroy
      # puts '좋아요 취소'
    end
      @result = @result.frozen?
  end

  def destroy_comment
    puts @c
    @c = Comment.find(params[:comment_id]).destroy
  end

  def page_scroll
    @posts = Post.order("updated_at DESC").page(params[:page])
  end

  private
    def is_login?   #before_action :authenticate_user해도 되는데 얘는 redirect_to를 발생 시켜서 ajax와 맞지 않다.
      unless user_signed_in?
        respond_to do |format|
          format.js { render 'please_login.js.erb'}
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :contents)
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
