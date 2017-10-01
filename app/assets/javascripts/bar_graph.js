// $(document).ready(function() {
//   $("#pie-form").on("submit", function(event){
//     console.log($(this))
//     event.preventDefault();
//     console.log("bound")
//     var $form = $(this)
//   $request = $.ajax({
//     url: $form.attr("url"),
//     data: $form.serialize(),
//     method: $form.attr("method")
//   })
//   $request.done(function(serverResponse){
//     $("#chart").empty();
//     console.log("the request is done!")
//     renderBarChart(serverResponse)
//     console.log(serverResponse)
//     renderDownloadButton();
//   })
//   })
// });

// var renderBarChart = function(dataset){
//   var height = 400,
//   width = 600,
//   barWidth = 50,
//   barOffset = 5;
//   console.log(height)

//   var yScale = d3.scaleLinear()

//   var svg = d3.select('#chart')
//   .append('svg')
//   .attr('width', width)
//   .attr('height', height)
//   // .style('background', '#C9D7D6')
//   // .attr('id', "d3-chart")

//   .selectAll('rect').data(dataset)
//   .enter().append('rect')
//   .style('fill', '#C61C6F')
//   .attr('width', barWidth)
//   .attr('height', function(d) {
//     return d;
//   })
//   .attr('x', function(d, i) {
//     return i*(barWidth + barOffset)
//   })
//   .attr('y', function(d) {
//     return height - d;
//   });
// }


// //   d3.selectAll("#test").style("color", "yellow");
// // console.log("hello")
// // var bardata = [20,30,45,15];
// // var height = 400,
// //     width = 600,
// //     barWidth = 50,
// //     barOffset = 5;

// // d3.select("#test").append('svg')
// //   .attr('width', width)
// //   .attr('height', height)
// //   .style('background', '#C9D7D6')
// // .selectAll('rect').data(bardata)
// //   .enter().append('rect')
// //     .style('fill','#C61C6F')
// //     .attr('width', barWidth)
// //     .attr('height', function(d){
// //       return d;
// //     })
// //     .attr('x', function(d){
// //       return i*(barWidth + barOffset)
// //     })
// //     .attr('y', function(d){
// //       return height -d;
// //     });
