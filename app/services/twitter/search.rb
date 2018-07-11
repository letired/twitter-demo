class Twitter::Search
  attr_reader :authenticator, :params, :data
  attr_accessor :errors

  def initialize(params)
    @authenticator = Twitter::Authenticator.new.call
    @params = Twitter::Parameters.new(params).call
    @errors = []
  end

  def call
    search
    verify_authenticator
    verify_params
    OpenStruct.new(content: data, errors: errors)
  end

  private

  # Custom exceptions from twitter gem rescued here for display
  def search
    @data ||= authenticator.content.search(params.content, count: 3)
  rescue Twitter::Error => e
    errors << e
  end

  def verify_authenticator
    errors << authenticator.errors unless authenticator.errors.empty?
  end

  def verify_params
    errors << params.errors unless params.errors.empty?
  end
end
