class Twitter::Parameters
  attr_reader :params, :errors

  def initialize(params)
    @params = params
    @errors = []
  end

  def call
    OpenStruct.new(content: verify_params(params), errors: errors)
  end

  private

  def verify_params(params)
    errors << 'No search term provided' if params.empty?
  end
end
