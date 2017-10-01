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

var chart = function(xAxis, yAxis){
  c3.generate({
    data: {
        x: 'x',
        columns: [
            xAxis,
            yAxis
        ],
        type: 'bar'
    },
    bar: {
        width: {
            ratio: 0.5 // this makes bar width 50% of length between ticks
        }
        // or
        //width: 100 // this makes bar width 100px
    }
});
}

var arrayify = function(serverResponse){
  var xAxis = ['x'];
  serverResponse.forEach(function(element) {
    xAxis.push(element["label"])
  })
  var yAxis = ['data1'];
  serverResponse.forEach(function(element) {
    yAxis.push(element["amount"])
  })
  chart(xAxis, yAxis)
}








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




