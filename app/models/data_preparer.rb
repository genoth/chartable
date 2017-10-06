module DataPreparer

  def prepared_data(dataset)
    if @params[:order] == "All"
      if should_condense?
        condense_others(sorted_by_amount(full_series(dataset)))
      else
        sorted_by_amount(full_series(dataset))
      end
    else
      limit_n_and_others(sorted_by_amount(full_series(dataset)))
    end
  end

  def full_series(dataset)
    dataset.map {|hash| [hash[:label], hash[:amount]]}
  end

  def sorted_by_amount(dataset)
    sorted_dataset = dataset.sort_by { |sub_array| sub_array[1] }
    sorted_dataset.reverse
  end

  def condense_others(dataset)
    limited = dataset.first(10)
    others = dataset.slice(limited.length, dataset.length)
    total_sum_others = others.reduce {|sum, sub_array| sub_array[1] }
    number_of_others = others.length
    others_condensed = [ "#{number_of_others} Others"]
    others_condensed.push(total_sum_others)
    limited.push(others_condensed)
  end


  def limit_n_and_others(dataset)
    limit_selected = (@params[:limit]).to_i
    if @params[:order] == "top"
      dataset.first(limit_selected)
    elsif @params[:order] == "bottom"
      dataset.last(limit_selected)
    end
  end
end