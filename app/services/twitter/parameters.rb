class Twitter::Parameters
  def self.call(params)
    new(params).call
  end

  def call
    verify_params
    OpenStruct.new(content: params, errors: errors)
  end

  private

  attr_reader :params, :errors

  def initialize(params)
    @params = params
    @errors = []
  end

  def verify_params
    no_params
    empty_params
  end

  def no_params
    errors << { parameter_error: 'No params provided' } if params.nil?
  end

  def empty_params
    errors << { parameter_error: 'No search term provided' } if params&.empty?
  end
end
