# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :find_article, only: %i[show update destroy]

  def index
    @articles = Article.all.limit(10).to_json({ include: 'comments' })
    json_response(@articles, :ok)
  end

  def create
    @article = Article.create(article_params)
    if @article.save
      json_response(@article, :created)
    else
      error_response('Something went wrong', :internal_server_error)
    end
  end

  def update
    if @article.update(article_params)
      json_response(@article, :created)
    else
      error_response('Something went wrong', :internal_server_error)
    end
  end

  def show
    json_response(@article).to_json({ include: 'comments' })
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
    params.require(:article).permit(:title, :content, :user_id, comment_ids: [])
  end
end
