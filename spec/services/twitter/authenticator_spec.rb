require 'rails_helper'

describe Twitter::Authenticator do
  describe '.call' do
    subject(:response) { described_class.call }

    context 'with no errors' do
      it 'returns an instance of the twitter client' do
        expect(response.content).to be_an_instance_of(Twitter::REST::Client)
      end
    end

    context 'with no credentials' do
      before { allow(Twitter::REST::Client).to receive(:new).and_return(client) }

      let(:client) do
        instance_double(Twitter::REST::Client, consumer_key: nil, consumer_secret: nil)
      end

      it 'errors' do
        expect(response.errors).to_not be_empty
      end
    end
  end
end
