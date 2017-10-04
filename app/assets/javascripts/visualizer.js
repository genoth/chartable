$(document).ready(function(){
  visFormHandler();
});

var visFormHandler = function(){
  $("#vis-form").on("submit",function(event){
    event.preventDefault();
    var $form = $(this);
    var chartType = $(":selected")[2].value;
    var $aggregatorToAppend = $(":selected")[0].value;
    var $descriptorToAppend = $(":selected")[1].value;
    $request = $.ajax({
      url: $form.attr("url"),
      data: $form.serialize(),
      method: $form.attr("method")
    })
    $request.done(function(serverResponse){
      $("#chart").empty();

      var subTitle = $aggregatorToAppend + " by " + $descriptorToAppend;
      var descriptives = serverResponse[0]
      var incomingData = serverResponse[1]
      var chartData = prepareData(incomingData, chartType);
      if(chartType === "bar" || chartType === "pie"){
        produceChart(chartData, chartType, subTitle);
      }
      else {
        produceChart(incomingData, chartType, subTitle);
      }
      renderDownloadButton();
    })
  })
}

var produceChart = function(data, type, descriptives){
  if (type === "pie") {
    renderPieChart(data, descriptives);
  } else if(type === "bar") {
    renderBarChart(data, descriptives);
  }
  else {
   return renderScatterPlot(data, subTitle);
  }
}

var renderPieChart = function(data, descriptives) {
  c3.generate({
      data: {
        columns: data,
        type:'pie'
      },
      pie: {
        label: {
          format: function (value, ratio, id) {
            return d3.format('$')(value) + descriptives.pie_chart_unit; // this should be a 'prefix' variable and a units variable
          }
        }
      },
      title: {
       text: descriptives.dataset_title
     }
   });
}

var renderBarChart = function(data, descriptives) {
  c3.generate({
    data: {
      columns: data,
      type : 'bar'
    },
    axis: {
      y: {
        label: descriptives.y_axis_label
      }
    },
    title: {
      text: descriptives.dataset_title
    }
  });
}

var renderScatterPlot = function(data, subTitle) {
  console.log("THIS IS THE DATA passed into the renderScatterPlot")
  console.log(data)

  var scatterplotColumns = scatterPlotCreateColumns(data);

  // maps each group's name to the label series. eg:
  // {
  //    "Male": "years_x",
  //    "Female": "years_x"
  //    "Both Sexes": "years_x"
  // }
  var labelData = {};
  for(i = 1; i < scatterplotColumns.length; i++) {
    labelData[scatterplotColumns[i][0]] = scatterplotColumns[0][0];
  }


  c3.generate({
    data: {
      xsort: false,
      xs: labelData,
      columns: scatterplotColumns,
      type: 'scatter'
    },
    title: {
      text: subTitle
    },
    axis: {
      x: {
        label: 'Year',
        tick: {
          fit: true,
        }
      },
      y: {
        label: 'Age'
      }
    }
  })
}


var prepareData = function(incomingData, chartType){
  incomingData.sort(function(a, b){
    return b.amount - a.amount;
  })
  var nestedArray = []
  incomingData.forEach(function(element){
    var label = element.label;
    var amount = Math.round(element.amount, 2);
    nestedArray.push([label, amount]);
  })
  var series = []
  if (chartType === 'pie') {
    series = nestedArray.slice(0, 10); // use a variable that slices the interesting bit of the data.
    var other = 0;
    for (var i = 10; i < nestedArray.length; i++) {
      other += nestedArray[i][1];
    }
    series.push([String(nestedArray.length - 10) + " Others", Math.round(other, 2)]) // this math might hcange slightly depending on the slicing above
  } else if (chartType === 'bar'){ // 'bar'
    series = nestedArray.slice(0, 10); // another dependency on the above
  }
  else if (chartType === 'scatter'){ // 'bar'
    series = nestedArray; // another dependency on the above
  }
  return series;
}


//create columns for scatter plot
// returns all unique labels in an array as a nested array
var removeDuplicates = function(labels){
  return labels.filter(function(label, index, self){
    return self.indexOf(label) == index;
  })
}

// this returns the groups for example, ["White", "Black", "All Races"]
var scatterGroups = function(data){
  var allLabels = []
  data.forEach(function(row){
    allLabels.push(row.label)
  })
  return removeDuplicates(allLabels)
}

var nestedColumns = function(uniqueArrayOfColumns){
  return uniqueArrayOfColumns.map(function(label){
    return [label]
  })
}

// this is the nested array C3 generator needs for scatterplot.
// [["White", 81, 80, 79]
// ["BLack", 79, 78, 76]
// ["All races", 81, 80, 79]]
var scatterPlotCreateColumns = function(data){
  var scatterLabels = nestedColumns(scatterGroups(data))
  var yearArray = ['years_x'];
  data.forEach(function(row){
    scatterLabels.forEach(function(labelArray){
      if(row["label"] === labelArray[0]){
        labelArray.push(row["amount"])
      }
    })
    if (yearArray[yearArray.length - 1] !== row["year"]) {
      yearArray.push(row["year"])
    }
  })
  console.log('YEAR ARRAY!!!', yearArray)
  scatterLabels.unshift(yearArray);

  console.log("these are the scatter labels!")
  console.log(scatterLabels)
  return scatterLabels
}

// [{label: "Black", amount: 32.9}, {label: "Black", amount: 32.2}, {label: "Black", amount: 32.5}, {label: "White", amount: 78.0}, {label: "White", amount: 79.1}, {label: "White", amount: 79.1}, {label: "White", amount: 79.1}, {label: "White", amount: 79.0}, {label: "White", amount: 78.9}, {label: "White", amount: 78.8}, {label: "White", amount: 78.5}]

var renderDownloadButton = function(){
  $("#download-div").removeClass("hidden");
  downloadHandler();
}

var downloadHandler = function(){
  $("#download-div").on("submit", function(event){
    event.preventDefault();
    saveSvgAsPng(($("svg")[0]), "chartable-diagram.png")
  })
}
