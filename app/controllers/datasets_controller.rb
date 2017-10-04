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
    descriptive_metadata = {
      :description => dataset_klass::metadata[:description],
      :dataset_title => dataset_klass::metadata[:dataset_title],
      :diagram_title => "#{params[:aggregations]} by #{params[:descriptors]}",
      :dataset_url => dataset_klass::metadata[:dataset_url],
      :dataset_source => dataset_klass::metadata[:dataset_source],
      :y_axis_label => dataset_klass::y_axis_label(params[:aggregations]),
      :pie_chart_unit => dataset_klass::pie_chart_unit}
    puts @dataset
    render json: [descriptive_metadata, @dataset]

  end

private

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



