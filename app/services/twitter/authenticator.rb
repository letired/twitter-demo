class Twitter::Authenticator
  attr_reader :errors, :client

  def self.call
    new.call
  end

  def call
    create_client
    verify_client
    OpenStruct.new(content: create_client, errors: errors)
  end

  private

  def initialize
    @errors = []
  end

  # KeyError exception is intentionally not rescued here
  def create_client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = add_secret(:CONSUMER_KEY)
      config.consumer_secret = add_secret(:CONSUMER_SECRET)
    end
  rescue Twitter::Error => e
    errors << { authenticator_error: e }
  end

  def verify_client
    verify_consumer_key
    verify_consumer_secret
  end

  def verify_consumer_key
    errors << { authenticator_error: 'missing consumer_key' } unless client.consumer_key
  end

  def verify_consumer_secret
    errors << { authenticator_error: 'missing consumer_secret' } unless client.consumer_secret
  end

  def add_secret(credentials)
    Rails.application.credentials&.twitter&.fetch(credentials)
  end
end
