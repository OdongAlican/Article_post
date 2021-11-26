# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  before(:each) do
    @user = FactoryBot.create(:user, first_name: 'John', last_name: 'Doe', gender: 'Male', address: 'Kampala', phone: '+25674592738')
    @article = FactoryBot.create(:article, title: 'ArticleOne', content: 'Test Article', user_id: @user.id)
    @commentOne = FactoryBot.create(:comment, content: 'First Comment', article_id: @article.id, user_id: @user.id)
    @commentTwo = FactoryBot.create(:comment, content: 'Second Comment', article_id: @article.id, user_id: @user.id)
    @commentThree = FactoryBot.create(:comment, content: 'Third Comment', article_id: @article.id, user_id: @user.id)
    @commentFour = FactoryBot.create(:comment, content: 'Fourth Comment', article_id: @article.id, user_id: @user.id)
  end
  describe 'GET all Comments', type: :request do
    it 'returns all comments' do
      get '/comments'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(4)
    end
  end
  describe 'GET one Comment' do
    context 'when comment exists' do
      it 'returns a single comment' do
        get "/comments/#{@commentOne.id}"
        expect(response).to have_http_status(:success)
        expect(json['id']).to eq(@commentOne.id)
      end
    end
    context 'when comment does not exist' do
      let(:comment_id) { 0 }
      it 'returns a no comment' do
        get "/comments/#{comment_id}"
        expect(response).to have_http_status(404)
        expect(json['id']).not_to eq(comment_id)
        expect(JSON.parse(response.body)).to include('message' => 'Record Not Found')
      end
    end
  end
  describe 'CREATE Comment' do
    context 'when request attributes are valid' do
      let(:valid_attributes) do
        { content: 'test content', user_id: @user.id, article_id: @article.id }
      end
      before { post '/comments', params: valid_attributes }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include('content' => 'test content')
      end
    end
    context 'when an invalid request' do
      before { post '/comments', params: {} }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to include('message' => 'Something went wrong')
      end
    end
  end
  describe 'UPDATE Comment' do
    let(:valid_attributes) do
      { content: 'New Comment', user_id: @user.id, article_id: @article.id }
    end
    context 'when comment is updated' do
      before { put "/comments/#{@commentOne.id}", params: valid_attributes }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
      it 'updates the comment' do
        updated_item = Comment.find(@commentOne.id)
        expect(updated_item.content).to match(/New Comment/)
        expect(updated_item.content).not_to match(/New Commenting/)
      end
    end
    context 'when the comment does not exist' do
      let(:comment_id) { 0 }
      before { put "/comments/#{comment_id}", params: valid_attributes }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns a not found message' do
        expect(JSON.parse(response.body)).to include('message' => 'Record Not Found')
      end
    end
  end
  describe 'DELETE Comment' do
    before { delete "/comments/#{@commentThree.id}" }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
