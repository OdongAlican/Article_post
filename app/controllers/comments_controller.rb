# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :find_comment, only: %i[show update destroy]

  def index
    @comments = Comment.all.limit(10)
    json_response(@comments, :ok)
  end

  def create
    @comment = Comment.create(comment_params)
    if @comment.save
      result = @comment.to_json({ include: 'user' })
      json_response(result, :created)
    else
      error_response('Something went wrong', :unprocessable_entity)
    end
  end

  def update
    if @comment.update(comment_params)
      json_response(@comment, :created)
    else
      error_response('Something went wrong', :unprocessable_entity)
    end
  end

  def show
    json_response(@comment)
  end

  def destroy
    @comment.destroy
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error_response('Record Not Found', :not_found)
  end

  def comment_params
    params.permit(:content, :user_id, :article_id)
  end
end
