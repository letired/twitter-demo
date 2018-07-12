require 'rails_helper'

describe TweetsController, type: :controller do
  describe 'GET #index' do
    subject(:index) { get :index }

    it 'sends redirect code' do
      index
      expect(response.status).to eq(302)
    end

    it 'redirects to the show with default search' do
      index
      expect(response).to redirect_to action: :show, q: 'adjust berlin'
    end
  end

  describe 'GET #show' do
    context 'successful search' do
      subject(:success) { get :show, params: { q: 'success test' } }

      before do
        allow(Twitter::Search)
          .to receive(:call)
          .and_return(OpenStruct.new(content: 'content', errors: []))
      end

      it 'calls search object' do
        expect(Twitter::Search).to receive(:call).with('success test')
        success
      end

      it 'assigns @tweets' do
        success
        expect(assigns(:tweets)).to eq('content')
      end
    end

    context 'failed search' do
      subject(:failure) { get :show, params: {q: 'failure test' } }

      before do
        allow(Twitter::Search)
          .to receive(:call)
          .and_return(OpenStruct.new(content: nil, errors: ['error message']))
      end

      it 'calls search object' do
        expect(Twitter::Search).to receive(:call).with('failure test')
        failure
      end

      it 'does not assign @tweets' do
        failure
        expect(assigns(:tweets)).to eq(nil)
      end

      it 'flashes error' do
        failure
        expect(flash[:error]).to eq(['error message'])
      end
    end
  end

  describe 'GET #search' do
    subject(:search) { get :search }

    it 'sends redirect code' do
      search
      expect(response.status).to eq(302)
    end

    it 'redirects to the show' do
      search
      expect(response).to redirect_to action: :show
    end

    it 'redirects params' do
      get :search, params: { q: 'test' }
      expect(response).to redirect_to action: :show, q: 'test'
    end
  end
end
