$(document).ready(function(){
  $("#pie-form").on("submit",function(event){
    event.preventDefault();
    var $form = $(this)
    var chartType = $(":selected")[2].value
    var $aggregatorToAppend = $(":selected")[0].value
    var $descriptorToAppend = $(":selected")[1].value
  $request = $.ajax({
    url: $form.attr("url"),
    data: $form.serialize(),
    method: $form.attr("method")
  })
  $request.done(function(serverResponse){
    console.log("This is the form from the ajax return")
    console.log($form)

    $("#chart").empty();
    var chartTitle = $aggregatorToAppend + " by " + $descriptorToAppend
    arrayify(serverResponse, chartType, chartTitle);
    renderDownloadButton();
  })
  })
});

var chart = function(data, type, chartTitle){
  if (type === "pie") {
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
  } else {
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
}

var arrayify = function(serverResponse, chartType, chartTitle){
 serverResponse.sort(function(a, b){
   return b.amount - a.amount;
 })
 var nestedArray = []
 serverResponse.forEach(function(element){
   var label = element["label"]
   var amount = Math.floor((element["amount"])/1000000)
   nestedArray.push([label, amount])
 })
 var limitTen = []
 for (var i = 0; i < 10; i++) {
   limitTen.push(nestedArray[i])
 }
 chart(limitTen, chartType, chartTitle);
}

var renderDownloadButton = function(){
  $("#download-div").removeClass("hidden");
  downloadHandler();
}

var downloadHandler = function(){
  $("#download-div").on("submit", function(event){
    event.preventDefault();
    // saveSvgAsPng((document.getElementsByTagName("svg")[0]), "chartable-diagram.png")
    saveSvgAsPng(($("svg")[0]), "chartable-diagram.png")
  })
}

// Need to limit to top 10 only for bar chart. Would need to render all data for pie chart, but aggregate the small slices into an "other employees" or whatever type function, preferrably with a number of employees. (e.g. "104")
// var arrayify = function(serverResponse, chartType, chartTitle){
//  serverResponse.sort(function(a, b){
//    return b.amount - a.amount;
//  })
//  var nestedArray = []
//  serverResponse.forEach(function(element){
//    var label = element["label"]
//    var amount = (element["amount"])/1000000
//    nestedArray.push([label, amount])
//  })
//  var formattedData = []
//  if (chartType === "pie") {
//   formattedData = nestedArray
// } else {
//  for (var i = 0; i < 10; i++) {
//    formattedData.push(nestedArray[i])
//  }
// }
// chart(formattedData, chartType, chartTitle);
// }

// var renderDownloadButton = function(){
//   $("#download-div").removeClass("hidden");
//   downloadHandler();
// }


