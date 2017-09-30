Rails.application.routes.draw do


  # Each dataset can be viewed, and you make a visualization
  get 'datasets/:id', to: 'datasets#show'
  post 'datasets/:id/query', to: 'datasets#query'

  # if we get to saving visualizations, use these
  # post 'datasets/:dataset_id/visualizations'
  # get 'datasets/:dataset_id/visualizations/:id'

  root 'topics#index'
end
