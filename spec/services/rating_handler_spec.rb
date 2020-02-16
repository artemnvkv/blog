require 'rails_helper'

RSpec.describe RatingHandler do
  let(:post) { PostHandler.execute(attributes_for(:post).merge!(login: 'test')).post }
  let(:rating_params) { { rating: nil, id: nil } }

  describe '#validation' do
    it 'should validate RatingHandler' do
      rating_handler = RatingHandler.execute(rating_params.merge(rating: 2, id: post.id))

      expect(rating_handler).to be_valid
    end

    it 'should validate presence of post' do
      rating_handler = RatingHandler.execute(rating_params.merge(rating: 2))

      expect(rating_handler).to_not be_valid
      expect(rating_handler.errors[:post]).to be
    end

    it 'should validate presence of rating' do
      rating_handler = RatingHandler.execute(rating_params.merge(id: post.id))

      expect(rating_handler).to_not be_valid
      expect(rating_handler.errors[:rating]).to be
    end

    it 'should validate the value of rating - must be 5 or less' do
      rating_handler = RatingHandler.execute(rating_params.merge(rating: 6, id: post.id))

      expect(rating_handler).to_not be_valid
      expect(rating_handler.errors[:rating]).to be
    end

    it 'should validate the value of rating - must be 1 or more' do
      rating_handler = RatingHandler.execute(rating_params.merge(rating: 0, id: post.id))

      expect(rating_handler).to_not be_valid
      expect(rating_handler.errors[:rating]).to be
    end
  end

  describe '#create' do
    context 'with correct params' do
      before do
        RatingHandler.execute(rating_params.merge(rating: 5, id: post.id))
      end

      it 'update post rating' do
        expect(Post.find(post.id).rating).to eq(5)
      end

      it 'update post sum_ratings' do
        expect(Post.find(post.id).sum_ratings).to eq(5)
      end

      it 'update post num_ratings' do
        expect(Post.find(post.id).num_ratings).to eq(1)
      end
    end

    context 'with incorrect params' do
      before do
        RatingHandler.execute(rating_params.merge(rating: 6, id: post.id))
      end

      it 'should not change post rating' do
        expect(Post.find(post.id).rating).not_to eq(6)
        expect(Post.find(post.id).rating).to eq(0)
      end

      it 'update post sum_ratings' do
        expect(Post.find(post.id).sum_ratings).not_to eq(6)
        expect(Post.find(post.id).sum_ratings).to eq(0)
      end

      it 'update post num_ratings' do
        expect(Post.find(post.id).num_ratings).not_to eq(1)
        expect(Post.find(post.id).num_ratings).to eq(0)
      end
    end
  end
end
