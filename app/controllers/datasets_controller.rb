class DatasetsController < ApplicationController
# get the form
  def show
    dataset_klass = data_sets[params[:id]]
    puts "got here"
    if !dataset_klass
      redirect_to '/'
      #render errors? flash?
      return
    end

    @diagram_form_inputs = {
      pie: {
        descriptors: dataset_klass.descriptors,
        aggregations: dataset_klass.aggregations
        # filters: {
        #   :departments => Trump::Department.all
        #   :employees => Employee.all
        # },
      },
      bar: {
        descriptors: dataset_klass.descriptors,#[:departments, :employees],
        aggregation: dataset_klass.aggregations # [:max_debts, :avg_debts]
      }
    }
  end


  def query
    dataset_klass = data_sets[params[:id]]
    if !dataset_klass
      redirect_to '/'
      #render errors? flash?
      return
    end


    @dataset = dataset_klass::Query.new(params).data
    render json: @dataset


  end

  def title
    TrumpAdminDebts::Query.generate_title
  end

private

  def data_sets
    {
      'trump' => TrumpAdminDebts
    }
  end

end

    # EXAMPLE JSON CONTRACT
    # if params[:aggregations] == "Maximum Debts"
    #   @aggregation = TrumpAdminDebts::Debts.all.to_json
    # end
    # dataset = [
    #          { label: 'White House', amount: 348085155 },
    #          { label: 'Department of Labor', amount: 1030004 },
    #          { label: 'Department of Education', amount: 3485019 },
    #          { label: 'Department of Treasury', amount: 10200036 }
    #        ]



