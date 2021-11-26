# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  before(:each) do
    @userOne = FactoryBot.create(:user, first_name: 'John', last_name: 'Doe', gender: 'Male', address: 'Kampala', phone: '+25674592738')
    @userTwo = FactoryBot.create(:user, first_name: 'Jane', last_name: 'Doe', gender: 'Female', address: 'Kampala', phone: '+25674592738')
  end

  describe 'GET Users' do
    it 'returns all users' do
      get '/users'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end
  describe 'GET one User' do
    context 'when user exists' do
      it 'returns a single user' do
        get "/users/#{@userOne.id}"
        expect(response).to have_http_status(:success)
        expect(json['id']).to eq(@userOne.id)
      end
    end
    context 'when user does not exist' do
      let(:user_id) { 0 }
      it 'returns a no user' do
        get "/users/#{user_id}"
        expect(response).to have_http_status(404)
        expect(json['id']).not_to eq(user_id)
        expect(JSON.parse(response.body)).to include('message' => 'Record Not Found')
      end
    end
  end
  describe 'CREATE User' do
    context 'when request attributes are valid' do
      let(:valid_attributes) do
        { first_name: 'test', last_name: 'user', gender: 'Male', address: 'Gulu', phone: '+256756234986' }
      end
      before { post '/users', params: valid_attributes }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include('address' => 'Gulu')
        expect(JSON.parse(response.body)).to include('first_name' => 'test')
      end
    end
    context 'when an invalid request' do
      before { post '/users', params: {} }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to include('message' => 'Something went wrong')
      end
    end
  end
  describe 'UPDATE User' do
    let(:valid_attributes) { { first_name: 'New User Name' } }
    context 'when user is updated' do
      before { put "/users/#{@userOne.id}", params: valid_attributes }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
      it 'updates the user' do
        updated_item = User.find(@userOne.id)
        expect(updated_item.first_name).to match(/New User Name/)
      end
    end
    context 'when the user does not exist' do
      let(:user_id) { 0 }
      before { put "/users/#{user_id}", params: valid_attributes }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns a not found message' do
        expect(JSON.parse(response.body)).to include('message' => 'Record Not Found')
      end
    end
  end
  describe 'DELETE User' do
    before { delete "/users/#{@userOne.id}" }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
