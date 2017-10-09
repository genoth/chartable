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
  if (orderSelector.val() === "Top" || orderSelector.val() === "Bottom") {
    $("#limit").show();
    console.log("MADE IT")
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
    var chartType = $(":selected")[2].value;
    $request = $.ajax({
      url: $form.attr("url"),
      data: $form.serialize(),
      method: $form.attr("method")
    })
    $request.done(function(serverResponse){
      $("#chart").empty();
      var descriptives = serverResponse[1]

      var dataTitle = descriptives.dataset_title
      var subTitle = descriptives.subtitle
      var chartTitle = [dataTitle + " - " + subTitle]

      var chartData = serverResponse[0]

      if(chartType === "bar") {
        renderBarChart(chartData, descriptives, chartTitle);
      } else if(chartType === "pie"){
        renderPieChart(chartData, descriptives, chartTitle);
      } else {
        renderScatterPlot(chartData, descriptives, chartTitle)
      }
      renderDownloadButton();
      renderURLButton();
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
  console.log(chartData)
  console.log(chartData[0])
  if ((chartData[0]).length > 2){
    timeSeries(chartData, descriptives, chartTitle);
  } else {
  console.log(chartData)
  c3.generate({
    data: {
      columns: chartData,
      type : 'bar'
    },
    axis: {
      y: {
        label: descriptives.y_axis_label
      }
    },
    title: {
      text: chartTitle
    }
  });
}
}

var timeSeries = function(chartData,descriptives, chartTitle) {
  console.log("in the time series")
  c3.generate({
    data: {
      columns: chartData,
      x: chartData[0][0],
      type : 'bar'
    },
    axis: {
      x: {
        label: descriptives.x_axis_label,
        position: 'outer-center',
        tick: {
          fit: false,
        },
        y: 0
      }
    },
    axis: {
      y: {
        label: {
          text: descriptives.y_axis_label,
          position: 'outer-center'
        }
      }
    },
    title: {
      text: chartTitle
    },
  grid: {
    y: {
      show: true,
      lines: [
      {value: 0},
      ]
    }
  }
  })
}

var renderScatterPlot = function(chartData, descriptives, chartTitle) {

  var showLabels = true;
  console.log("this thing is making the chart data")
  console.log(chartData[0][0]);
  if (chartData[0].length > 20) {
    showLabels = true;
  }
  c3.generate({
    point: {
      r: 4
    },
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
        label: descriptives.x_axis_label,
        tick: {
          fit: true,
        }
      },
      y: {
        label: {
          text: descriptives.y_axis_label,
          position: 'outer-center'
        }
      }
    },
    grid: {
    y: {
      show: true,
      lines: [
      {value: 0},
      ]
    }
  }
  })
}

var renderDownloadButton = function(){
  $("#download-div").removeClass("hidden");
  downloadHandler();
}

var renderURLButton = function(){
  var currentPath = window.location.pathname
  var params = $("#vis-form select").serialize()
  var urlforSharing = currentPath + "?" + params
  $("#url-div a").text("Share")
  $("#url-div a").attr("href", urlforSharing)
  shareClickListener()
}

var shareClickListener = function(){
  $(".share").on("click", function(e){
    $("link-share").text("");
    e.preventDefault();
    renderURL();
  })
}

var renderURL = function(){
  // $("#url-div a").attr("href", urlforSharing)
  var currentPath = window.location.pathname
  var params = $("#vis-form select").serialize()
  var urlforSharing = currentPath + "?" + params
  $("#administrative-metadata").append("<p class='link-share'>Bookmark or share your chart with this link:</p>")
  $("#administrative-metadata").append("<p class='link-share'>" + urlforSharing + "</p>")
  // $("#url-div a").attr("href").text ("<p>" + urlforSharing + "</p>")
}

var downloadHandler = function(){
  $("#download-div").on("submit", function(event){
    event.preventDefault();
    saveSvgAsPng(($("svg")[0]), "chartable-diagram.png")
  })
}

// var renderURL = function(){
//   // $("#url-div a").attr("href", urlforSharing)
//   var currentPath = window.location.pathname
//   var params = $("#vis-form select").serialize()
//   var urlforSharing = currentPath + "?" + params
//   var fullURL = 'http://chartable.herokuapp.com' + urlforSharing
//   var fullURLwithTags = "<a href=" + fullURL + "></a>"
//   $("#administrative-metadata").append("<p class='link-share'>Bookmark or share your chart with this link:</p>")
//   $("#administrative-metadata").append("<p class='link-share'>" + fullURLwithTags + "</p>")
//   // $("#url-div a").attr("href").text ("<p>" + urlforSharing + "</p>")
// }
