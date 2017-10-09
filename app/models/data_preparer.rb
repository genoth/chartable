module DataPreparer

  def prepared_data(dataset)
    if @params[:order] == "All"
      if should_condense?
        thing = condense_others(sorted_by_amount(full_series(dataset)))
      elsif should_sort_by_amount?
        thing = sorted_by_amount(full_series(dataset))
      else
        thing = full_series(dataset)
      end
    else
      thing = limit_n_and_others(sorted_by_amount(full_series(dataset)))
    end
    # tried formatting it the way it's done in canadian temperature data- doesn't work getting NaN error. I think because the departments are strings (as opposed to the years which are integers)
    #  x_axis = ["x_departments"]
    # y_axis = ["money stuff"]

    # thing.each do |subarray|
    #   x_axis.push(subarray[0])
    #   y_axis.push(subarray[1])
    # end
    # sending_back = []
    # p sending_back.push(x_axis, y_axis)
    # sending_back
  end

  def full_series(dataset)
    dataset.map {|hash| [hash[:label], (hash[:amount]).round(1)]}
  end

  def sorted_by_amount(dataset)
    sorted_dataset = dataset.sort_by { |sub_array| sub_array[1] }
    sorted_dataset.reverse
  end

  def condense_others(dataset)
    limited = dataset.first(10)
    others = dataset.slice(limited.length, dataset.length)

    total_sum_others = others.reduce(0) {|sum, sub_array| sum + sub_array[1] }

    number_of_others = others.length
    others_condensed = [ "#{number_of_others} Others"]
    others_condensed.push(total_sum_others.to_i)
    limited.push(others_condensed)
  end


  def limit_n_and_others(dataset)
    limit_selected = (@params[:limit]).to_i
    if @params[:order] == "Top"
      dataset.first(limit_selected)
    elsif @params[:order] == "Bottom"
      dataset.last(limit_selected)
    end
  end
end
