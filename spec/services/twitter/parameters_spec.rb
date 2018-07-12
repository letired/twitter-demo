require 'rails_helper'

describe Twitter::Parameters do
  describe '.call' do
    subject(:response) { described_class.call(params) }

    shared_examples 'success' do
      it 'has no errors' do
        expect(response.errors).to be_empty
      end

      it 'returns content' do
        expect(response.content).to eq(params)
      end
    end

    shared_examples 'failure' do
      it 'returns errors' do
        expect(response.errors).to_not be_empty
      end

      it 'returns content' do
        expect(response.content).to eq(params)
      end
    end

    context 'with successful verification' do
      let(:params) { 'a search' }

      it_behaves_like 'success'
    end

    context 'with empty params' do
      let(:params) { nil }

      it_behaves_like 'failure'
    end

    context 'with empty string' do
      let(:params) { '' }

      it_behaves_like 'failure'
    end
  end
end
