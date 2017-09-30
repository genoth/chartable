Rails.application.routes.draw do

  get 'datasets/:id', to: 'datasets#show'

  root 'topics#index'
end
