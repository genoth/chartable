Rails.application.routes.draw do


  # Each dataset can be viewed, and you make a visualization
  resources :datasets, only: [:show] do
    member do
      post :query
    end

    resources :visualizations, only: [:create, :show]
  end

  get '/visualizations', to: 'visualizations#index'




  # if we get to saving visualizations, use these
  # post 'datasets/:dataset_id/visualizations'
  # get 'datasets/:dataset_id/visualizations/:id'

  root 'topics#index'
end
