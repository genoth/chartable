module GenderInequality

    def self.descriptors
      ["GenderData.country"]
    end

    def self.aggregations
      aggregation_sql_snippits.keys
    end

    def self.aggregation_sql_snippits
      "Percentage of Women with Some Secondary Education, ages 25 and up" => "share_of_women_w_some_secondary_education_25_and_up_2005_2014"
      "Share of Men with Some Secondary Education, ages 25 and up" => "share_of_men_w_some_secondary_education"
    end

    def self.data_points
    end

    def self.metadata
      {
      description: "This data is collected by the United Nations Development Programme and reflects the disadvantages faced by women worldwide in terms of reproductive health and participation in education, political office, and the workforce. Data is reported 'for as many countries as data of reasonable quality allow.' The index itself ranges from 0 to 1, with 0 meaning that men and women fare equally. Individual statistics are also reported and measured in percentages, as well as rate per 1000 (adolscent birth rate) or per 100,000 (maternal mortality).",
      dataset_title: "Gender Inequality Index Data",
      dataset_url: "https://data.humdata.org/dataset/gender-inequality-index"
      dataset_source: "United Nations Development Programme"
      }
    end
end

