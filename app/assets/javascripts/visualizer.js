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
      var chartData = prepareData(serverResponse, chartType);

      produceChart(chartData, chartType, subTitle);
      renderDownloadButton();
    })
  })
}

var produceChart = function(data, type, subTitle){

  if (type === "pie") {
    renderPieChart(data, subTitle);
  } else {
    renderBarChart(data, subTitle);
  }
}

var renderPieChart = function(data, subTitle) {
  var source = $("form input#dataset_source").val()
  var link = $("form input#dataset_url").val()
  var title = $("form input#dataset_title").val()
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
       text: title + ", " + subTitle
     }
   });
}

var renderBarChart = function(data, subTitle) {
  var source = $("form input#dataset_source").val()
  var link = $("form input#dataset_url").val()
  var title = $("form input#dataset_title").val()
  c3.generate({
    data: {
      columns: data,
      type : 'bar'
    },
    axis: {
      x: {
            label: source + "\n" + link
        },
      y: {
        label:'In Millions' // this should be a variable
      }
    },
    title: {
      text: title + ", " + subTitle
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
    series = nestedArray.slice(0, 10); // use a variable that slices the interesting bit of the data. for education rate of women, you'd want to look at the last 10.
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



