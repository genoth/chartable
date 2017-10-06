$(document).ready(function(){
  visFormListener();
  orderDropdownListener();
  loadGraph();
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

var visFormListener = function(){
  $("#vis-form").on("submit",function(event){
    event.preventDefault();
    loadGraph();
  })
}

var loadGraph = function(){
  var $form = $("#vis-form");
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
      renderURL();
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

  var showLabels = true;
  if (chartData[0].length > 20) {
    showLabels = false;
  }

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
    legend: {
      hide: showLabels
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

var renderURL = function(){
  var currentPath = window.location.pathname
  var params = $("#vis-form select").serialize()
  var urlforSharing = currentPath + "?" + params
  $("#url-div a").attr("href", urlforSharing)
  // $("#url-div a").attr("href").text (urlforSharing)
}

var downloadHandler = function(){
  $("#download-div").on("submit", function(event){
    event.preventDefault();
    saveSvgAsPng(($("svg")[0]), "chartable-diagram.png")
  })
}
