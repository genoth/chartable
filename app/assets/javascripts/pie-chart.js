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
    arrayify(serverResponse);
    renderDownloadButton();
  })
  })
});

var pieChart = function(data){
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
    }
  });
}
var barChart = function(myColumns){
  c3.generate({
    data: {
        columns: myColumns,
        type : 'bar'
    },
    axis: {
      y: {
        label:'Label Placeholder'
      }
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
   var amount = (element["amount"])/1000000
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

var renderDownloadButton = function(){
  $("#download-div").removeClass("hidden");

  downloadHandler();
}

var downloadHandler = function(){
  $("#download-form").on("submit", function(event){
    event.preventDefault();
    console.log("bound")
    saveSvgAsPng(document.getElementById("chart"), "chartable-diagram.png")
  })
}


// var pieData = {};
// var xAxis = [];
// var hashify = function(serverResponse){
//   serverResponse.forEach(function(e) {
//       xAxis.push(e.label);
//       pieData[e.label] = e.amount;
//   })
  // console.log(pieData)
  // console.log(xAxis)
// }

