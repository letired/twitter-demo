# frozen_string_literal: true

class TweetsController < ApplicationController
  def index
    redirect_to controller: 'tweets', action: 'show', q: 'adjust berlin'
  end

  def show
    results = Twitter::Search.new(search_params[:q]).call
    if results.errors.empty?
      @tweets = results.content
    else
      results.errors.each do |error|
        flash[:error] = error
      end
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
