require 'rails_helper'

describe Twitter::Search do
  describe '#call' do
    subject(:search) { Twitter::Search.call('awesome search') }

    # Happy Setup
    let(:client) { instance_double(Twitter::REST::Client, search: 'search results') }

    let(:authenticator) do
      allow(Twitter::Authenticator).to receive(:call)
        .and_return(OpenStruct.new(content: client, errors: []))
    end

    let(:parameters) do
      allow(Twitter::Parameters).to receive(:call).with('awesome search')
        .and_return(OpenStruct.new(content: 'awesome search', errors: []))
    end

    # Contexts
    context 'successful search' do
      before do
        authenticator
        parameters
      end

      it { is_expected.to respond_to :content }
      it { is_expected.to respond_to :errors }

      it 'returns search results' do
        expect(search.content).to eq('search results')
      end

      it 'has no errors' do
        expect(search.errors).to be_empty
      end
    end

    context 'unsuccesful search' do
      before do
        parameters
      end

      it 'handles search exception' do
        twitter_error = Twitter::Error.new('Unavailable')
        allow(client).to receive(:search).and_raise(twitter_error)

        allow(Twitter::Authenticator).to receive(:call)
          .and_return(OpenStruct.new(content: client, errors: []))

        expect(search.errors).to eq([{ search_error: twitter_error }])
      end
    end

    context 'parameter error' do
      before do
        authenticator
        allow(Twitter::Parameters).to receive(:call).with('awesome search')
          .and_return(OpenStruct.new(content: 'awesome search', errors: [{ parameter_error: 'No params provided' }]))
      end

      it 'populates errors' do
        expect(search.errors).to eq([{ parameter_error: 'No params provided' }])
      end

      it 'does not search' do
        search
        expect(client).to_not receive(:search)
      end
    end

    context 'authenticator error' do
      before do
        parameters
        allow(Twitter::Authenticator).to receive(:call)
          .and_return(OpenStruct.new(content: client, errors: [{ error: 'auth' }]))
      end

      it 'populates errors' do
        expect(search.errors).to eq([{ error: 'auth' }])
      end

      it 'does not search' do
        search
        expect(client).to_not receive(:search)
      end
    end
  end
end
