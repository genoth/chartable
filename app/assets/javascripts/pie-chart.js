$(document).ready(function(){
  $("#pie-form").on("submit",function(event){
    event.preventDefault();
    console.log("bound")
    $form = $(this)
    console.log($form.attr("method"))
  $request = $.ajax({
    url: $form.attr("url"),
    data: $form.serialize(),
    method: $form.attr("method")
  })
  $request.done(function(serverResponse){
    //renderPieChart(serverResponse)
    renderC3Chart();
    renderDownloadButton();
  })
  })
});

var renderC3Chart = function() {
var chart = c3.generate({
    data: {
        // iris data from R
        columns: [
            ['data1', 30],
            ['data2', 120],
        ],
        type : 'pie',
        onclick: function (d, i) { console.log("onclick", d, i); },
        onmouseover: function (d, i) { console.log("onmouseover", d, i); },
        onmouseout: function (d, i) { console.log("onmouseout", d, i); }
    }
});
}

var renderPieChart = function(dataset){
  console.log('AHHHHHHHH');
  var width = 600;
  var height = 600;
  var radius = Math.min(width, height) / 2;

  var color = d3.scaleOrdinal(d3.schemeCategory20b);

  var svg = d3.select('#chart')
  .append('svg')
  .attr('width', width)
  .attr('height', height)
  .attr('id', "d3-chart")
  .append('g')
  .attr('transform', 'translate(' + (width / 2 ) + ',' + (height / 2) + ')');

  var arc = d3.arc()
  .innerRadius(0)
  .outerRadius(radius);

  var pie = d3.pie()
  .value(function(d) { return d.amount; })
  .sort(null);

  var path = svg.selectAll('path')
  .data(pie(dataset))
  .enter()
  .append('path')
  .attr('d', arc)
  .attr('fill', function(d) {
    return color(d.data.label);
})
console.log(dataset)
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


// ;

