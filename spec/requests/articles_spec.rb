# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Articles API', type: :request do
  before(:each) do
    @user = FactoryBot.create(:user, first_name: 'John', last_name: 'Doe', gender: 'Male', address: 'Kampala', phone: '+25674592738')
    @articleOne = FactoryBot.create(:article, title: 'ArticleOne', content: 'Test Article', user_id: @user.id)
    @articleTwo = FactoryBot.create(:article, title: 'ArticleTwo', content: 'Test Article', user_id: @user.id)
    @articleThree = FactoryBot.create(:article, title: 'ArticleThree', content: 'Test Article', user_id: @user.id)
  end
  describe 'GET all Articles', type: :request do
    it 'returns all articles' do
      get '/articles'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
  describe 'GET one Article' do
    context 'when article exists' do
      it 'returns a single article' do
        get "/articles/#{@articleOne.id}"
        expect(response).to have_http_status(:success)
        expect(json['id']).to eq(@articleOne.id)
      end
    end
    context 'when article does not exist' do
      let(:article_id) { 0 }
      it 'returns a no article' do
        get "/articles/#{article_id}"
        expect(response).to have_http_status(404)
        expect(json['id']).not_to eq(article_id)
        expect(JSON.parse(response.body)).to include('message' => 'Record Not Found')
      end
    end
  end
  describe 'CREATE Article' do
    context 'when request attributes are valid' do
      let(:valid_attributes) do
        { title: 'First Article', content: 'Article content', user_id: @user.id }
      end
      before { post '/articles', params: valid_attributes }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include('title' => 'First Article')
        expect(JSON.parse(response.body)).to include('content' => 'Article content')
      end
    end
    context 'when an invalid request' do
      before { post '/articles', params: {} }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to include('message' => 'Something went wrong')
      end
    end
  end
  describe 'UPDATE Article' do
    let(:valid_attributes) do
      { title: 'New Article Title', content: 'New content', user_id: @user.id }
    end
    context 'when article is updated' do
      before { put "/articles/#{@articleOne.id}", params: valid_attributes }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
      it 'updates the article' do
        updated_item = Article.find(@articleOne.id)
        expect(updated_item.title).to match(/New Article Title/)
        expect(updated_item.title).not_to match(/Some Random Title/)
        expect(updated_item.content).to match(/New content/)
        expect(updated_item.content).not_to match(/Some Random Content/)
      end
    end
    context 'when the article does not exist' do
      let(:article_id) { 0 }
      before { put "/articles/#{article_id}", params: valid_attributes }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns a not found message' do
        expect(JSON.parse(response.body)).to include('message' => 'Record Not Found')
      end
    end
  end
  describe 'DELETE Article' do
    before { delete "/articles/#{@articleOne.id}" }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
