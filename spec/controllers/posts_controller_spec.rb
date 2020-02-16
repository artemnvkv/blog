require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe '#GET :index' do
    before do
      user = create(:user)
      create_list(:post, 10, user: user)
    end

    context 'when request without parameter' do
      before { get :index }

      it 'should returns posts' do
        result = JSON.parse(response.body)
        expect(result).not_to be_empty
        expect(result.size).to eq(10)
      end

      it 'should returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request with `per` param' do
      before { get :index, params: { per: 5 } }

      it 'should returns top n posts' do
        result = JSON.parse(response.body)
        expect(result).not_to be_empty
        expect(result.size).to eq(5)
      end

      it 'should returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#POST :create' do
    let(:correct_params) do
      {
        title: 'test_title',
        body: 'test_body',
        ip_address: '192.168.1.1',
        login: 'artem'
      }
    end

    context 'when request is correct' do
      before { post :create, params: correct_params }

      it 'should create post' do
        result = JSON.parse(response.body)
        expect(result['title']).to eq(correct_params[:title])
      end

      it 'should returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request is incorrect' do
      before { post :create, params: { title: 'Test title' } }

      it 'should returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe '#PUT :update' do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:correct_params) do
      {
        id: post.id,
        rating: 5
      }
    end

    context 'when request is correct' do
      before { put :update, params: correct_params }

      it 'should creates a rating' do
        result = JSON.parse(response.body)
        expect(result).to be_between(0, 5)
      end

      it 'should returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request is incorrect' do
      before { put :update, params: { id: post.id } }

      it 'should returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe '#GET :ip_list' do
    before do
      create_list(:user, 2) do |user|
        create(:connection, ip_address: '192.168.1.1', user: user)
      end
      get :ip_list
    end

    it 'should return IP list' do
      result = JSON.parse(response.body)
      expect(result).not_to be_empty
    end

    it 'should returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
