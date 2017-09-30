Rails.application.routes.draw do

  get 'datasets/:id', to: 'datasets#show'
  post 'datasets/query'

  root 'topics#index'
end
