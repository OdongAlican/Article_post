# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: %i[show update destroy]

  def index
    @users = User.limit(limit).offset(params[:offset]).to_json({ include: ['comments', { articles: { include: 'comments' } }] })
    json_response(@users, :ok)
  end
  { roles: { include: 'permissions' } }
  { include: { roles: { include: 'permissions' } } }
  def create
    @user = User.create(user_params)
    if @user.save
      json_response(@user, :created)
    else
      error_response('Something went wrong', :unprocessable_entity)
    end
  end

  def update
    if @user.update(user_params)
      json_response(@user, :created)
    else
      error_response('Something went wrong', :unprocessable_entity)
    end
  end

  def show
    json_response(@user.to_json({ include: ['comments', { articles: { include: 'comments' } }] }))
  end

  def destroy
    @user.destroy
  end

  private

  def limit
    [params.fetch(:limit, 10).to_i, 10].min
  end

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error_response('Record Not Found', :not_found)
  end

  def user_params
    params.permit(:first_name, :last_name, :gender, :address, :phone, article_ids: [], comment_ids: [])
  end
end
