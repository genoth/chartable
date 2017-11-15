class VisualizationsController < ApplicationController

  def show
    @visualization = Visualization.find(params[:id])
    data = @visualization.image_blob
    send_data data, type: 'image/png', disposition: 'inline'

    # data = open("http://www.gravatar.com/avatar/c2713a4959692f16d27d2553fb06cc4b.png?r=x&s=170")
    # send_data(data, type: 'image/png', disposition: 'inline')
  end

  def create
    link = params['link']
    image_data = params['uri']
    dataset_id = params['dataset_id']

    @visualization = Visualization.find_by(link: link)
    if @visualization == nil
      response = Cloudinary::Uploader.upload(image_data)
      p response
      @visualization = Visualization.create(link: link, public_id: response['public_id'], dataset_id: dataset_id)
      flash[:notice] = "Chart successfully saved to Chartable library."
    else
      flash[:alert] = "This chart already exists in the Chartable library."
    end
  end

  def index
    @visualizations = Visualization.all
    p @visualizations
  end

end