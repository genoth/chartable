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

      produceChart(chartData, chartType, descriptives);
      renderDownloadButton();
    })
  })
}

var produceChart = function(data, type, descriptives){
  if (type === "pie") {
    renderPieChart(data, descriptives);
  } else {
    renderBarChart(data, descriptives);
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
  } else { // 'bar'
    series = nestedArray.slice(0, 10); // another dependency on the above
  }
  return series;
}



