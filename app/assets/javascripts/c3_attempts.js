// $(function () {
// var chart = c3.generate({
//     data: {
//         columns: [
//             ['data1', 30, 200, 100, 400, 150, 250],
//             ['data2', 50, 20, 10, 40, 15, 25]
//         ]
//     }
// });
// });

// var chart = c3.generate({
//     data: {
//         columns: [
//             ['data1', 30, 200, 100, 400, 150, 250],
//             ['data2', 130, 100, 140, 200, 150, 50]
//         ],
//         type: 'bar'
//     },
//     bar: {
//         width: {
//             ratio: 0.5 // this makes bar width 50% of length between ticks
//         }
//         // or
//         //width: 100 // this makes bar width 100px
//     }
// });

// // });

// setTimeout(function () {
//     chart.load({
//         columns: [
//             ['data3', 130, -150, 200, 300, -200, 100]
//         ]
//     });
// }, 1000);

// var renderC3Chart = c3.generate({
//   bindto: d3.select('#chart'),
//   data: {
//     columns: [
//       ['data1', 30, 200, 100, 400, 150, 250],
//       ['data2', 50, 20, 10, 40, 15, 25]
//     ]
//   }
// });


// var renderC3Chart = c3.generate({
//     data: {
//         // iris data from R
//         columns: [
//             ['data1', 30],
//             ['data2', 120],
//         ],
//         type : 'pie',
//         onclick: function (d, i) { console.log("onclick", d, i); },
//         onmouseover: function (d, i) { console.log("onmouseover", d, i); },
//         onmouseout: function (d, i) { console.log("onmouseout", d, i); }
//     }
// });

// setTimeout(function () {
//     chart.load({
//         columns: [
//             ["setosa", 0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.3, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.1, 0.2, 0.4, 0.4, 0.3, 0.3, 0.3, 0.2, 0.4, 0.2, 0.5, 0.2, 0.2, 0.4, 0.2, 0.2, 0.2, 0.2, 0.4, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1, 0.2, 0.2, 0.3, 0.3, 0.2, 0.6, 0.4, 0.3, 0.2, 0.2, 0.2, 0.2],
//             ["versicolor", 1.4, 1.5, 1.5, 1.3, 1.5, 1.3, 1.6, 1.0, 1.3, 1.4, 1.0, 1.5, 1.0, 1.4, 1.3, 1.4, 1.5, 1.0, 1.5, 1.1, 1.8, 1.3, 1.5, 1.2, 1.3, 1.4, 1.4, 1.7, 1.5, 1.0, 1.1, 1.0, 1.2, 1.6, 1.5, 1.6, 1.5, 1.3, 1.3, 1.3, 1.2, 1.4, 1.2, 1.0, 1.3, 1.2, 1.3, 1.3, 1.1, 1.3],
//             ["virginica", 2.5, 1.9, 2.1, 1.8, 2.2, 2.1, 1.7, 1.8, 1.8, 2.5, 2.0, 1.9, 2.1, 2.0, 2.4, 2.3, 1.8, 2.2, 2.3, 1.5, 2.3, 2.0, 2.0, 1.8, 2.1, 1.8, 1.8, 1.8, 2.1, 1.6, 1.9, 2.0, 2.2, 1.5, 1.4, 2.3, 2.4, 1.8, 1.8, 2.1, 2.4, 2.3, 1.9, 2.3, 2.5, 2.3, 1.9, 2.0, 2.3, 1.8],
//         ]
//     });
// }, 1500);

// setTimeout(function () {
//     chart.unload({
//         ids: 'data1'
//     });
//     chart.unload({
//         ids: 'data2'
//     });
// }, 2500);

// var renderC3Chart = function(){
// var chart = c3.generate({
//     data: {
//         columns: [
//             ['data1', 30],
//             ['data2', 50]
//         ],
//         type: 'pie'
//     },
//     pie: {
//         label: {
//             format: function (value, ratio, id) {
//                 return d3.format('$')(value);
//             }
//         }
//     }
// });
// }

// var renderC3Chart = function(){
//   order_labels = {
//     'a': [
//       'a',
//       'e',
//       'c',
//       'd'
//     ]
//   };

//   readable_labels = {
//     "a": 'Test 1',
//     'e': 'Test 2',
//     'c': 'Test 3',
//     'd': 'Test 4'
//   };
//   order_labels["a"].forEach(function(d) {
//     new_panels = d3.select("#page-wrapper").append('#chart').attr('class', "panel panel-default");
//     new_panels.append('#chart').attr('class', "panel-heading").text(function() {
//       return readable_labels[d];
//     });
//     new_panels.append('#chart').attr('class', "panel-body").append('#chart').attr("id", function() {
//       return d + "graph_wrapper";
//     });
//     new_panels.append('#chart').attr('class', "panel-footer");
//   });

//   var chart = c3.generate({
//     bindto: '#agraph_wrapper',
//     data: {
//       columns: [
//         ['data1', 30, 200, 100, 400, 150, 250],
//         ['data2', 50, 20, 10, 40, 15, 25]
//       ]
//     }
//   });

//   var chart1 = c3.generate({
//     bindto: '#dgraph_wrapper',
//     data: {
//       columns: [
//         ['data1', 30, 200, 100, 400, 150, 250],
//         ['data2', 50, 20, 10, 40, 15, 25]
//       ]
//     }
//   })
// }
// var renderC3Chart = function() {
//   var chart = c3.generate({
//     data: {
//         columns: [
//             ['data1', parseInt(30)],
//             ['data2', parseInt(50)]
//         ],
//         type: 'pie'
//     },
//     pie: {
//         label: {
//             format: function (value, ratio, id) {
//                 return d3.format('$')(value);
//             }
//         }
//     }
// });

// }
// var renderC3Chart = function() {
// var chart = c3.generate({
//     data: {
//         // iris data from R
//         columns: [
//             ['data1', 30],
//             ['data2', 120],
//         ],
//         type : 'pie',
//         onclick: function (d, i) { console.log("onclick", d, i); },
//         onmouseover: function (d, i) { console.log("onmouseover", d, i); },
//         onmouseout: function (d, i) { console.log("onmouseout", d, i); }
//     }
// });
// }
