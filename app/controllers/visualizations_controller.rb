class VisualizationsController < ApplicationController

  def show
    @visualization = Visualization.find(params[:id])
    data = @visualization.image_blob
    send_data data, type: 'image/png', disposition: 'inline'

    # data = open("http://www.gravatar.com/avatar/c2713a4959692f16d27d2553fb06cc4b.png?r=x&s=170")
    # send_data(data, type: 'image/png', disposition: 'inline')
  end

  def create
    # image_blob = request.body.read
    # Visualization.create!(image_blob: image_blob)
    link = params['link']
    image_data = params['uri']
    p link
    # p "this is the request body (read) to json **********************"
    # p request.body.read.to_json
    # image_data = request.body.read.to_json

    # data = image_data['link']
    # p "this should be the link *********************************"
    # # p data
    # Visualization.create!(link: link)
    # Cloudinary::Uploader.upload(image_data, options = {public_id: link})
  end

end