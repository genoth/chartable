class DatasetsController < ApplicationController
# get the form
  def show
    dataset_klass = data_sets[params[:id]]
    @metadata = dataset_klass.metadata
    # @title = metadata[:dataset_title]
    # @source = metadata[:dataset_source]
    # @url = metadata[:dataset_url]

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
    metadata = dataset_klass.metadata
    @source = metadata[:dataset_source]
    if !dataset_klass
      redirect_to '/'
      #render errors? flash?
      return
    end

    @dataset = dataset_klass::Query.new(params).data
    p @dataset
    render json: @dataset
  end

  def data_sets
    {
      'trump' => TrumpAdminDebts,
      'life_expectancy' => USLifeExpectancy,
      'gender_inequality' => GenderInequality
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



