$(document).ready(function(){
  visFormHandler();
  orderDropdownListener();
});

var orderDropdownListener = function(){
  $("#order").on("change", orderDropdownHandler)
}

var orderDropdownHandler = function(){
  var orderSelector = $("#order")
  if (orderSelector.val() === "top" || orderSelector.val() === "bottom") {
    $("#limit").show();
  } else {
    $("#limit").hide();
  }
}

var visFormHandler = function(){
  $("#vis-form").on("submit",function(event){
    event.preventDefault();
    var $form = $(this);
    console.log($form.attr("url"));
    var chartType = $(":selected")[2].value;
    $request = $.ajax({
      url: $form.attr("url"),
      data: $form.serialize(),
      method: $form.attr("method")
    })
    $request.done(function(serverResponse){
      $("#chart").empty();
      console.log(serverResponse)
      var descriptives = serverResponse[1]
      var dataTitle = descriptives.dataset_title
      var subTitle = descriptives.subtitle
      var chartTitle = [dataTitle + " - " + subTitle]
      var chartData = serverResponse[0]

      if(chartType === "bar") {
        renderBarChart(chartData, descriptives, chartTitle)
      } else if(chartType === "pie"){
        renderPieChart(chartData, descriptives, chartTitle);
      } else {
        renderScatterPlot(chartData, descriptives, chartTitle)
      }
      renderDownloadButton();
    })
  })
}

var renderPieChart = function(chartData, descriptives, chartTitle) {
  c3.generate({
      data: {
        columns: chartData,
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

var renderBarChart = function(chartData, descriptives, chartTitle) {
  c3.generate({
    data: {
      columns: chartData,
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

var renderScatterPlot = function(chartData, descriptives, chartTitle) {
  c3.generate({
    data: {
      xsort: false,
      x:  chartData[0][0],
      columns: chartData,
      type: 'scatter'
    },
    title: {
      text:  chartTitle
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
