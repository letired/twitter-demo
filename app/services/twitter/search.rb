# frozen_string_literal: true

class Twitter::Search
  NUMBER_OF_TWEETS = 5

  def self.call(params)
    new(params).call
  end

  def call
    verification_check
    search if errors.empty?
    OpenStruct.new(content: search_data, errors: errors.flatten)
  end

  private

  attr_reader :authenticator, :params, :search_data, :errors

  def initialize(params)
    @authenticator = Twitter::Authenticator.call
    @params = Twitter::Parameters.call(params)
    @errors = []
  end

  def search
    @search_data ||= authenticator.content.search(params.content, count: NUMBER_OF_TWEETS)
  rescue Twitter::Error => e
    errors << { search_error: e }
  end

  def verification_check
    verify_authenticator
    verify_params
  end

  def verify_authenticator
    errors << authenticator.errors unless authenticator.errors.empty?
  end

  def verify_params
    errors << params.errors unless params.errors.empty?
  end
end
