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

      var x_axis_label = descriptives.x_axis_label
      var y_axis_label = descriptives.y_axis_label

      var chartData = serverResponse[0]
      console.log("this is the server response")
      console.log(serverResponse)

      if(chartType === "bar") {
        renderBarChart(chartData, descriptives, chartTitle)
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
  c3.generate({
    data: {
      columns: chartData,
      type : 'bar'
    },
    axis: {
      x: {
        label: descriptives.x_axis_label,
        tick: {
          fit: true,
        }
      }
    },
    axis: {
      y: {
        label: descriptives.y_axis_label  // this should be a variable
      }
    },
    title: {
      text: chartTitle
    }
  });
}

var renderScatterPlot = function(chartData, descriptives, chartTitle) {

  var showLabels = true;
  console.log(chartData);
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
        label: descriptives.y_axis_label
      }
    }
  })
}

var renderTimeSeries = function(){

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
