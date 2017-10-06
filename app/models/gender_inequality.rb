module GenderInequality

    def self.descriptors
      ["Country"]
    end

    def self.orders
      ["Top", "Bottom", "All"]
    end

    def self.aggregations
      aggregation_sql_snippits.keys
    end

    def self.aggregation_sql_snippits
      {
        # "Maternal Mortality per 100,000" => "maternal_mortality_per_100k_2013",
        # "Adolescent Birth Rate per 1,000" => "adolescent_birth_rate_per_1k",
        "Women's share of seats in Parliament" => "womens_share_of_seats_in_parliament_2014",
      "Share of Women with Some Secondary Education, ages 25 and up" => "share_of_women_w_some_secondary_education_25_and_up_2005_2014",
      "Share of Men with Some Secondary Education, ages 25 and up" => "share_of_men_w_some_secondary_education",
      "Share of Women in the Workforce" => "women_labor_force_participation_rate_15_and_up_2013",
      "Share of Men in the Workforce" => "men_labor_force_participation_rate"
      }
    end

    # metadata notes
    # write a method that determines the appropriate y-axis label for a bar chart based on the form submission
    # write a method that determines a unit (e.g. percentage, per 1000, etc.) for the pie chart based on the form submission
    # define the data type of each column
    # define the number of columns?
    # define the column names

    def self.metadata
      {
      description: "This data is collected by the United Nations Development Programme and reflects the disadvantages faced by women worldwide in terms of reproductive health and participation in education, political office, and the workforce. Data is reported 'for as many countries as data of reasonable quality allow.' The index itself ranges from 0 to 1, with 0 meaning that men and women fare equally. Individual statistics are also reported and measured in percentages.",
      dataset_title: "Gender Inequality Index Data",
      dataset_url: "https://data.humdata.org/dataset/gender-inequality-index",
      dataset_source: "United Nations Development Programme"
      }
    end
end

