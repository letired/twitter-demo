class Twitter::Authenticator
  attr_accessor :errors

  def self.call
    new.call
  end

  def call
    create_client
    OpenStruct.new(content: create_client, errors: errors)
  end

  private

  def initialize
    @errors = []
  end

  def create_client
    Twitter::REST::Client.new do |config|
      config.consumer_key = credentials(:CONSUMER_KEY)
      config.consumer_secret = credentials(:CONSUMER_SECRET)
    end
  rescue Twitter::Errors => e
    errors << { authenticator_error: e }
  end

  def credentials(type)
    Rails.application.credentials.twitter.fetch(type)
  end
end
