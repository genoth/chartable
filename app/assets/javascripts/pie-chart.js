$(document).ready(function(){
  $("#pie-form").on("submit",function(event){
    event.preventDefault();
    var $form = $(this)
    // var $aggregatorToAppend = $("#pie-form")["0"].children[3].children["0"].firstChild.data
     var $aggregatorToAppend = $("#pie-form")["0"].children[3].children[1].text
    var $descriptorToAppend = $("#pie-form")["0"].children[2].children[1].text
    console.log($form.attr("method"))
    console.log("This form!!!!!!!!!")
    console.log($form)
  $request = $.ajax({
    url: $form.attr("url"),
    data: $form.serialize(),
    method: $form.attr("method")
  })
  $request.done(function(serverResponse){
    $("#chart").empty();
    $("#diagram-title").text($aggregatorToAppend + " by " + $descriptorToAppend)
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
        label:'In Millions'
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
    // saveSvgAsPng((document.getElementsByTagName("svg")[0]), "chartable-diagram.png")
    saveSvgAsPng(($("svg")[0]), "chartable-diagram.png")
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

