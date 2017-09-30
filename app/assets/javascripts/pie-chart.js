$(document).ready(function(){
  $("#pie-form").on("submit",function(event){
    event.preventDefault();
    console.log("bound")
  })
});


var renderPieChart = function(){
  var dataset = ajaxreturn

  var width = 600;
  var height = 600;
  var radius = Math.min(width, height) / 2;

  var color = d3.scaleOrdinal(d3.schemeCategory20b);

  var svg = d3.select('#chart')
  .append('svg')
  .attr('width', width)
  .attr('height', height)
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
  (window.d3);
}

