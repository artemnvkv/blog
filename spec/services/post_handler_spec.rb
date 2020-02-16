require 'rails_helper'

RSpec.describe PostHandler do
  describe '#validation' do
    let(:post_params) { attributes_for(:post) }

    it 'should validate the presence of title' do
      post_handler = PostHandler.new(attributes_for(:post, title: nil))

      expect(post_handler).to_not be_valid
      expect(post_handler.errors[:title]).to be
    end

    it 'should validate the presence of body' do
      post_handler = PostHandler.new(attributes_for(:post, body: nil))

      expect(post_handler).to_not be_valid
      expect(post_handler.errors[:body]).to be
    end

    it 'should validate the presence of login' do
      post_handler = PostHandler.new(attributes_for(:post, login: nil))

      expect(post_handler).to_not be_valid
      expect(post_handler.errors[:login]).to be
    end

    it 'should validate the presence of ip_address' do
      post_handler = PostHandler.new(attributes_for(:post, ip_address: nil))

      expect(post_handler).to_not be_valid
      expect(post_handler.errors[:ip_address]).to be
    end
  end

  describe '#create' do
    context 'with correct params' do
      let!(:user) { create(:user) }
      let(:post_params) { attributes_for(:post).merge!(login: user.login) }

      it 'should create post and user in the database' do
        expect { PostHandler.execute(post_params) }.to change(Post, :count).by(1)
      end

      it 'should not create a user in the database' do
        expect { PostHandler.execute(post_params) }.to_not change(User, :count)
      end

      context 'post with new user' do
        let(:new_user_post_params) { attributes_for(:post).merge!(login: 'test') }

        it 'creates user in database' do
          expect { PostHandler.execute(new_user_post_params) }.to change(User, :count).by(1)
        end
      end
    end

    context 'with incorrect params' do
      let(:post_params) { attributes_for(:post, title: nil) }

      it 'should not create post in database' do
        expect { PostHandler.execute(post_params) }.to_not change(Post, :count)
      end

      it 'should not create user in database' do
        expect { PostHandler.execute(post_params) }.to_not change(User, :count)
      end
    end
  end
end
