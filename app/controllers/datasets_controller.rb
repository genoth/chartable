class DatasetsController < ApplicationController
# get the form
  def show
    @dataset_klass = data_sets[params[:id]]
    # puts "got here"
    if !@dataset_klass
      redirect_to '/'
      #render errors? flash?
      return
    end
    @descriptive_metadata = @dataset_klass.metadata
    @diagram_types = allowed_charts[params[:id]]
    # puts "these are the diagram types"
    # p @diagram_types
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
      'gender_inequality' => {:scatter => "Scatter Plot", :bar => "Bar Graph"},
      'canadian_climate' => {:scatter => "Scatter Plot", :bar => 'Bar Chart'}
    }
  end

  # should we put the x-axis y-axis data in here?

  # Canadian Climate:
    # x-axis will always be years (timeseries)
    # y-axis will always be temperature deviations

  # Gender Inequality:
    # Scatter:
      # x-axis will always be the percentage
      # y-axis will be the GII
    # Bar
      # x-axis will be the country labeled
      # y-axis will be the percentage

  # Life Expectancy
    # Scatter:
      # x-axis will always be the years (timeseries) e.g. 1950
      # y-axis will always be the life expectancy in years (e.g. 80 years old)
    # Bar?

  # Trump Data
    # Bar
      # x-axis will always be the categories/departments named
      # y-axis will always be the amount in millions

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



