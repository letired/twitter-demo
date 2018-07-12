require 'rails_helper'

describe TweetsController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    it { is_expected.to have_http_status 302 }
    it { is_expected.to redirect_to action: :show, q: 'adjust berlin' }
  end

  describe 'GET #show' do
    subject(:show) { get :show, params: { q: 'test search' } }

    context 'successful search' do
      before do
        allow(Twitter::Search)
          .to receive(:call)
          .and_return(OpenStruct.new(content: 'content', errors: []))
      end

      it 'calls search object' do
        expect(Twitter::Search).to receive(:call).with('test search')
        show
      end

      it 'assigns @tweets' do
        show
        expect(assigns(:tweets)).to eq('content')
      end
    end

    context 'failed search' do
      before do
        allow(Twitter::Search)
          .to receive(:call)
          .and_return(OpenStruct.new(content: nil, errors: ['error message']))
      end

      it 'calls search object' do
        expect(Twitter::Search).to receive(:call).with('test search')
        show
      end

      it 'does not assign @tweets' do
        show
        expect(assigns(:tweets)).to eq(nil)
      end

      it 'flashes error' do
        show
        expect(flash[:error]).to eq(['error message'])
      end
    end
  end

  describe 'GET #search' do
    subject { get :search, params: { q: 'test' } }

    it { is_expected.to have_http_status 302 }
    it { is_expected.to redirect_to action: :show, q: 'test' }
  end
end
