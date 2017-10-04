module GenderInequality

    def self.descriptors
      ["Country"]
    end

    def self.aggregations
      aggregation_sql_snippits.keys
    end

    def self.aggregation_sql_snippits
      {
      "Gender Inequality Index" => "gender_inequality_index_2014",

      "Gender Inequality Index - World Rank" => "gender_inequality_index_rank_2014",

      "Maternal Mortality per 100,000" => "maternal_mortality_per_100k_2013",

      "Adolescent Birth Rate per 1,000" => "adolescent_birth_rate_per_1k",

      "Women's Share of Seats in Parliament" => "womens_share_of_seats_in_parliament_2014",

      "Percentage of Women with Some Secondary Education, ages 25 and up" => "share_of_women_w_some_secondary_education_25_and_up_2005_2014",

      "Share of Men with Some Secondary Education, ages 25 and up" => "share_of_men_w_some_secondary_education",

      "Percentage of Women in the Workforce (ages 15 and up" => "women_labor_force_participation_rate_15_and_up_2013",

      "Percentage of Men in the Workforce (ages 15 and up" => "men_labor_force_participation_rate"
      }
    end

    def self.y_axis_label(aggregation)
      if aggregation == "Gender Inequality Index"
        return "Index of 0 to 1, with 0 meaning that men and women fare equally."
      elsif aggregation == "Gender Inequality Index - World Rank"
        return "World rank"
      elsif aggregation == "Maternal Mortality per 100,000"
        return "rate per 100,000"
      elsif aggregation == "Adolescent Birth Rate per 1,000"
        return "rate per 1,000"
      else
        return "percentage"
      end
    end

    def self.metadata
      {
      description: "This data is collected by the United Nations Development Programme and reflects the disadvantages faced by women worldwide in terms of reproductive health and participation in education, politics, and the workforce. Data is reported 'for as many countries as data of reasonable quality allow.'",
      dataset_title: "Gender Inequality Index Data",
      dataset_url: "https://data.humdata.org/dataset/gender-inequality-index",
      dataset_source: "United Nations Development Programme"
      }
    end
end




    # metadata notes

    # write a method that determines the appropriate y-axis label for a bar chart based on the form submission

    # write a method that determines a unit (e.g. percentage, per 1000, etc.) for the pie chart based on the form submission

    # define the data type of each column

    # define the number of columns?

    # define the column names
