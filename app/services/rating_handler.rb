class RatingHandler
  include ActiveModel::Validations

  validates :post_id, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  attr_reader :rating, :post_id, :average_rating

  def self.execute(params)
    new(params).tap(&:update_post_rating)
  end

  def initialize(params)
    @rating = params[:rating]
    @post_id = params[:id]
  end

  def update_post_rating
    return self unless valid?

    ActiveRecord::Base.transaction do
      post = Post.lock.find(@post_id)

      sum_ratings = post.sum_ratings.to_i + @rating.to_i
      num_ratings = post.num_ratings.to_i + 1
      @average_rating = sum_ratings / num_ratings

      post.update!(rating: @average_rating, sum_ratings: sum_ratings, num_ratings: num_ratings)
    end

    self
  end
end
