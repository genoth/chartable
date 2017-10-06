class DatasetsController < ApplicationController
# get the form
  def show
    dataset_klass = data_sets[params[:id]]
    # puts "got here"
    if !dataset_klass
      redirect_to '/'
      #render errors? flash?
      return
    end
    @descriptive_metadata = dataset_klass.metadata
    @diagram_types = allowed_charts[params[:id]]
    # puts "these are the diagram types"
    # p @diagram_types

    @diagram_form_inputs = {
      pie: {
        descriptors: dataset_klass.descriptors,
        aggregations: dataset_klass.aggregations
        # filters: {:departments => Trump::Department.all, :employees => Employee.all },
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

    subtitle = {subtitle: "#{params[:aggregations]} by #{params[:descriptors]}"}
    @descriptive_metadata = dataset_klass.metadata.merge(subtitle)
    @dataset = dataset_klass::Query.new(params).data

    render json: [@dataset, @descriptive_metadata]
  end


private
  def data_sets
    {
      'trump' => TrumpAdminDebts,
      'life_expectancy' => USLifeExpectancy,
      'gender_inequality' => GenderInequality,
      'canadian_climate' => CanadianClimate
    }
  end

  def allowed_charts
    {
      'trump' => {:pie => "Pie Chart", :bar => "Bar Chart"},
      'life_expectancy' => {:scatter => "Scatter Plot"},
      'gender_inequality' => {:bar => "Bar Graph", :scatter => "Scatter Plot"},
      'canadian_climate' => {:scatter => "Scatter Plot", :bar => 'Bar Chart'}
    }
  end


end

    # EXAMPLE JSON CONTRACT
  # def chart_types
  #   {
  #     'pie', "Pie Chart"],
  #     'bar' => "Bar Chart",
  #     'scatter' => "Scatter Plot"
  #   }
  # end
    # if params[:aggregations] == "Maximum Debts"
    #   @aggregation = TrumpAdminDebts::Debts.all.to_json
    # end
    # dataset = [
    #          { label: 'White House', amount: 348085155 },
    #          { label: 'Department of Labor', amount: 1030004 },
    #          { label: 'Department of Education', amount: 3485019 },
    #          { label: 'Department of Treasury', amount: 10200036 }
    #        ]



