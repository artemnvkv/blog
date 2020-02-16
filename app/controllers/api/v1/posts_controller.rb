class Api::V1::PostsController < Api::V1::BaseController
  # GET api/v1/posts?per=10
  def index
    post = Post.order(rating: :desc).limit(params[:per] || 10)

    render json: post
  end

  # POST api/v1/posts
  def create
    post_handler = PostHandler.execute(params)

    if post_handler.valid?
      render json: post_handler.post
    else
      render json: post_handler.errors, status: 422
    end
  end

  # PUT api/v1/posts/1
  def update
    rating_handler = RatingHandler.execute(params)

    if rating_handler.valid?
      render json: rating_handler.average_rating
    else
      render json: rating_handler.errors, status: 422
    end
  end

  # GET api/v1/posts/ip_list?per=10
  def ip_list
    render json: ConnectionsQuery.new(params[:per]).ip_list
  end
end
