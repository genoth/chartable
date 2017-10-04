$(document).ready(function(){
  visFormHandler();
});

var visFormHandler = function(){
  $("#vis-form").on("submit",function(event){
    event.preventDefault();
    var $form = $(this);
    console.log($form.attr("url"));
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
      var chartTitle = $aggregatorToAppend + " by " + $descriptorToAppend;
      var chartData = prepareData(serverResponse, chartType);
      if(chartType === "bar" || chartType === "pie"){
        produceChart(chartData, chartType, chartTitle);
      }
      else {
        produceChart(serverResponse, chartType, chartTitle);
      }
      renderDownloadButton();
    })
  })
}

var produceChart = function(data, type, chartTitle){
  if (type === "pie") {
    renderPieChart(data, chartTitle);
  } else if (type === "bar") {
    renderBarChart(data, chartTitle);
  }
  else {
   return renderScatterPlot(data, chartTitle);
  }
}

var renderPieChart = function(data, chartTitle) {
  c3.generate({
      data: {
        columns: data,
        type:'pie'
      },
      pie: {
        label: {
          format: function (value, ratio, id) {
            return d3.format('$')(value)+"M"; // this should be a 'prefix' variable and a units variable
          }
        }
      },
      title: {
       text: chartTitle
     }
   });
}

var renderBarChart = function(data, chartTitle) {
  c3.generate({
    data: {
      columns: data,
      type : 'bar'
    },
    axis: {
      y: {
        label:'In Millions' // this should be a variable
      }
    },
    title: {
      text: chartTitle
    }
  });
}

var renderScatterPlot = function(data, chartTitle) {
  c3.generate({
    data: {
      xsort: false,
      columns:scatterPlotCreateColumns(data),
      type: 'scatter'
    },
    title: {
      text: chartTitle
    }
  })
}


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

var prepareData = function(serverResponse, chartType){
  serverResponse.sort(function(a, b){
    return b.amount - a.amount;
  })
  var nestedArray = []
  serverResponse.forEach(function(element){
    var label = element.label;
    var amount = element.amount;
    nestedArray.push([label, amount]);
  })
  var series = []

  if (chartType === 'pie') {
    series = nestedArray.slice(0, 10); // use a variable that slices the interesting bit of the data. for education rate of women, you'd want to look at the last 10.
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

var scatterPlotLabels = function(data){
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

var scatterPlotCreateColumns = function(data){
  var scatterLabels = nestedColumns(scatterPlotLabels(data))
  data.forEach(function(row){
    scatterLabels.forEach(function(labelArray){
      if(row["label"] === labelArray[0]){
        labelArray.push(row["amount"])
      }
    })
  })
  return scatterLabels
}

// [{label: "Black", amount: 32.9}, {label: "Black", amount: 32.2}, {label: "Black", amount: 32.5}, {label: "White", amount: 78.0}, {label: "White", amount: 79.1}, {label: "White", amount: 79.1}, {label: "White", amount: 79.1}, {label: "White", amount: 79.0}, {label: "White", amount: 78.9}, {label: "White", amount: 78.8}, {label: "White", amount: 78.5}]
