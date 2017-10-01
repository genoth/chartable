$(document).ready(function(){
  $("#pie-form").on("submit",function(event){
    event.preventDefault();
    console.log("bound")
    var $form = $(this)
    console.log($form.attr("method"))
  $request = $.ajax({
    url: $form.attr("url"),
    data: $form.serialize(),
    method: $form.attr("method")
  })
  $request.done(function(serverResponse){
    $("#chart").empty();
    console.log(serverResponse)
    // renderPieChart(serverResponse)
    // renderC3Chart();
    arrayify(serverResponse);

    renderDownloadButton();
  })
  })
});

var chart = function(myColumns){
  c3.generate({
    data: {
        columns: myColumns,
        type : 'bar'
    },
    donut: {
        title: "Dogs love:",
    }
});
}

var arrayify = function(serverResponse){
  serverResponse.sort(function(a, b){
    return b.amount - a.amount;
  })

  var nestedArray = []
  serverResponse.forEach(function(element){
    var label = element["label"]
    var amount = element["amount"]
    nestedArray.push([label, amount])
  })
  console.log("this is nested Array!!!!")
  console.log(nestedArray);
  var limitTen = []
  for (var i = 0; i < 10; i++) {
    limitTen.push(nestedArray[i])
  }
  chart(limitTen);
}
// var arrayify = function(serverResponse){
//   var xAxis = [];
//   serverResponse.forEach(function(element) {
//     xAxis.push(element["label"])
//   })
//   var yAxis = [];
//   serverResponse.forEach(function(element) {
//     yAxis.push(element["amount"])
//   })
//   console.log(xAxis)
//   console.log(yAxis)
// }








var renderDownloadButton = function(){
  $("#download-div").removeClass("hidden");
  downloadHandler();
}

var downloadHandler = function(){
  $("#download-form").on("submit", function(event){
    event.preventDefault();
    console.log("bound")
    saveSvgAsPng(document.getElementById("d3-chart"), "chartable-diagram.png")
  })
}




