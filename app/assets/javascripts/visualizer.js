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
      var chartTitle = [descriptives.dataset_title + " - " + descriptives.subtitle]
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

var renderPieChart = function(chartData, descriptives, chartTitle) {
  c3.generate({
      data: {
        columns: chartData,
        type:'pie'
      },
      pie: {
        label: {
          format: function (value, ratio, id) {
            var dollars = d3.format('$')(value)+"M";
            var percentage = d3.format('%')(ratio.toFixed(4));
            return dollars
            // + ' (' + percentage + ')'// if we have other datasets that use pie charts, this should be a 'prefix' variable and a units variable
          }
        }
      },
      title: {
       text: chartTitle
     },
     tooltip: {
        format: {
          title: function(value, ratio, id){
            return id; },
          value: function(value, ratio, id){
            var dollars = d3.format('$')(value)+"M";
            var percentage = d3.format('%')(ratio.toFixed(4));
            return dollars + ' (' + percentage + ')'
            // if we have other datasets that use pie charts, this should be a 'prefix' variable and a units variable
          }
        }
      }
   });
 }

var renderBarChart = function(chartData, descriptives, chartTitle) {
  var barLabelsChoice = true;
  var legendChoice = false;

  if (chartData.length > 20) {
    legendChoice = true;
  }
  if (chartData.length > 10 || chartData[0].length > 10) {
    barLabelsChoice = false
  }
  if (descriptives.x_axis_label === "Year"){
    timeSeries(chartData, descriptives, chartTitle);
  } else {
  c3.generate({
    data: {
      columns: chartData,
      type : 'bar',
      labels: barLabelsChoice
    },
    axis: {
      y: {
        label: descriptives.y_axis_label
      },
      x: {
        type: 'category'
      }
    },
    title: {
      text: chartTitle
    },
    legend: {
      hide: legendChoice
    },
    grid: {
    y: {
      show: true,
      lines: [
      {value: 0},
      ]
    },
  }
  })
    removeZeroBug();
}
}

var removeZeroBug = function(){
  var gTick = $(".c3-axis.c3-axis-x").find("g.tick")
  gTick.find("text").find("tspan").html("");
  gTick.find("line").attr("y2", "");
  // This only fixes it on the first render. After you interact with the diagram (e.g. click to hide Trump's debts the bug comes back.)
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
        tick: {
          fit: false,
        }
      },
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
  console.log(chartData)
  console.log(descriptives)
  var legendChoice = false;

  if (chartData.length > 20) {
    legendChoice = true;
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
      hide: legendChoice
    },
    axis: {
      x: {
        label: {
          text: descriptives.x_axis_label,
          position: 'right'
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
    }
  }
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

//  This is to label each individual column rather than have a legend. IT's pretty ugly and impractical. All comes as same color
// var chart = function(chartData, descriptives, chartTitle){
//   c3.generate({
//     data: {
//         x : 'x',
//         columns: chartData,
//         type: 'bar'
//     },
//     axis: {
//         x: {
//             type: 'category',
//             tick: {
//                 rotate: 55,
//                 multiline: false
//             },
//             height: 130
//         }
//     }
// });
// }
