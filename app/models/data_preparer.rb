module DataPreparer

  def prepared_data(dataset)
    if @params[:order] == "All"
      if should_condense?
        condense_others(sorted_by_amount(full_series(dataset)))
      elsif should_sort_by_amount?
        sorted_by_amount(full_series(dataset))
      else
        full_series(dataset)
      end
    else
      limit_n_and_others(sorted_by_amount(full_series(dataset)))
    end
  end

  def full_series(dataset)
    dataset.map {|hash| [hash[:label], (hash[:amount]).round(1)]}
  end

  def sorted_by_amount(dataset)
    sorted_dataset = dataset.sort_by { |sub_array| sub_array[1] }
    puts "this is sorted by amount"
    p sorted_dataset.reverse
    sorted_dataset.reverse
  end

  def condense_others(dataset)
    limited = dataset.first(10)
    others = dataset.slice(limited.length, dataset.length)
    total_sum_others = others.reduce(0) {|sum, sub_array| sum + sub_array[1] }
    number_of_others = others.length
    others_condensed = [ "#{number_of_others} Others"]
    others_condensed.push(total_sum_others.round(1))
    limited.push(others_condensed)
  end


  def limit_n_and_others(dataset)
    limit_selected = (@params[:limit]).to_i
    if @params[:order] == "Top"
      selected = dataset.first(limit_selected)
    elsif @params[:order] == "Bottom"
      selected = dataset.last(limit_selected)
    end
    p selected
    selected
  end
end
