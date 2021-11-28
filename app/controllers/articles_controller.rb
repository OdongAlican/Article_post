# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :find_article, only: %i[show update destroy]

  def index
    @articles = Article.all.limit(10).to_json({ include: %w[user comments] })
    json_response(@articles, :ok)
  end

  def create
    @article = Article.create(article_params)
    if @article.save
      result = @article.to_json({ include: %w[user] })
      json_response(result, :created)
    else
      error_response('Something went wrong', :unprocessable_entity)
    end
  end

  def update
    if @article.update(article_params)
      json_response(@article, :created)
    else
      error_response('Something went wrong', :unprocessable_entity)
    end
  end

  def show
    data = @article.to_json({ include: ['user', { comments: { include: 'user' } }] })
    json_response(data)
  end

  def destroy
    @article.destroy
  end

  private

  def find_article
    @article = Article.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error_response('Record Not Found', :not_found)
  end

  def article_params
    params.permit(:title, :content, :user_id, comment_ids: [])
  end
end
