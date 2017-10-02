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
      console.log(serverResponse);
      $("#chart").empty();
      var chartTitle = $aggregatorToAppend + " by " + $descriptorToAppend;
      var chartData = prepareData(serverResponse, chartType);

      produceChart(chartData, chartType, chartTitle);
      renderDownloadButton();
    })
  })
}

var produceChart = function(data, type, chartTitle){
  if (type === "pie") {
    renderPieChart(data, chartTitle);
  } else {
    renderBarChart(data, chartTitle);
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
            return d3.format('$')(value)+"M";
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
        label:'In Millions'
      }
    },
    title: {
      text: chartTitle
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
    series = nestedArray.slice(0, 10);
    var other = 0;
    for (var i = 10; i < nestedArray.length; i++) {
      other += nestedArray[i][1];
    }
    series.push([String(nestedArray.length - 10) + " Others", Math.round(other, 2)])
  } else { // 'bar'
    series = nestedArray.slice(0, 10);
  }
  return series;
}



