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
    // renderPieChart(serverResponse)
    // renderC3Chart();
    chart();
    renderDownloadButton();
  })
  })
});

var chart = function(){c3.generate({
    data: {
        columns: [
            ['data1', 30, 200, 100, 400, 150, 250],
            ['data2', 50, 20, 10, 40, 15, 25]
        ]
    }
});
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




