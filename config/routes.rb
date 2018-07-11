Rails.application.routes.draw do
  root 'tweets#index'
  get 'tweets', action: :show, controller: 'tweets'
  get 'search', action: :search, controller: 'tweets'
end
