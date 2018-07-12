# frozen_string_literal: true

class TweetsController < ApplicationController
  def index
    redirect_to controller: 'tweets', action: 'show', q: 'adjust berlin'
  end

  def show
    results = Twitter::Search.call(search_params[:q])
    if results.errors.empty?
      @tweets = results.content
    else
      flash[:error] = results.errors
    end
  end

  def search
    redirect_to controller: 'tweets', action: 'show', q: search_params[:q]
  end

  private

  def search_params
    params.permit(:q)
  end
end
