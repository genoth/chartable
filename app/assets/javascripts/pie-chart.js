$(document).ready(function(){
  $("#pie-form").on("submit",function(event){
    event.preventDefault();
    console.log("bound")
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

var chart = function(myColumns){
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
    saveSvgAsPng((document.getElementsByTagName("svg")[0]), "chartable-diagram.png")
  })
}




