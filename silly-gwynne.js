
var chart = c3.generate({
    data: {
        xs: {
            usa: 'percentage_x',
            ca: 'percentage_x',
        },
        // iris data from R
        columns: [
            ["percentage_x", 0, 1, 2, 3, 4, 5],
            ["usa", 0.1],
            ["ca", 0.5, 0.3, 0.3, 0.9, 0.5],
        ],
        type: 'scatter'
    },
    axis: {
        x: {
            label: 'Sepal.Width',
            tick: {
                fit: false
            }
        },
        y: {
            label: 'Petal.Width'
        }
    }
});




[
  [
    ["White House", 387.085],
    ["Department of Commerce", 44.365],
    ["Department of the Treasury", 39.755],
    ["Department of Education", 6.225],
    ["Department of Housing and Urban Development", 4.065],
    ["Environmental Protection Agency", 3.925],
    ["Department of the Interior", 2.55],
    ["Department of Labor", 2.1],
    ["Department of Agriculture", 1.55], [
    "Department of Health and Human Services", 1.28],
    ["Others", 6.779999999999999]
  ],
  [
    {hello: "hi", this_cool: "yep"}
  ]
]


$(document).ready(function(){
  visFormHandler();
});

var visFormHandler = function(){
  $("#vis-form").on("submit",function(event){
    event.preventDefault();
    var $form = $(this);
    console.log($form.attr("url"));
    var chartType = $(":selected")[2].value;
    $request = $.ajax({
      url: $form.attr("url"),
      data: $form.serialize(),
      method: $form.attr("method")
    })
    $request.done(function(serverResponse){
      $("#chart").empty();
      console.log("this is the server response weeeeeeeee")
      console.log(serverResponse)
      var descriptives = serverResponse[1]
      var dataTitle = descriptives.dataset_title
      var subTitle = descriptives.subtitle
      var chartTitle = [dataTitle + " - " + subTitle]

      var chartData = serverResponse[0]

      if(chartType === "bar") {
        renderBarChart(chartData, descriptives, chartTitle)
      } else if(chartType === "pie"){
        renderPieChart(chartData, descriptives, chartTitle);
      } else {
        renderScatterPlot(chartData, descriptives, chartTitle)
      }
      renderDownloadButton();
    })
  })
}

// var produceChart = function(data, type, chartTitle){
//   if (type === "pie") {
//     renderPieChart(data, chartTitle);
//   } else {
//     renderBarChart(data, chartTitle);
//   }
// }

var renderPieChart = function(chartData, descriptives, chartTitle) {
  c3.generate({
      data: {
        columns: chartData,
        type:'pie'
      },
      pie: {
        label: {
          format: function (value, ratio, id) {
            return d3.format('$')(value)+"M"; // this should be a 'prefix' variable and a units variable
          }
        }
      },
      title: {
       text: chartTitle
     }
   });
}

var renderBarChart = function(chartData, descriptives, chartTitle) {
  c3.generate({
    data: {
      columns: chartData,
      type : 'bar'
    },
    axis: {
      y: {
        label:'In Millions' // this should be a variable
      }
    },
    title: {
      text: chartTitle
    }
  });
}

var renderScatterPlot = function(chartData, descriptives, chartTitle) {
  c3.generate({
    data: {
      xsort: false,
      x:  chartData[0][0],
      columns: chartData,
      type: 'scatter'
    },
    title: {
      text:  chartTitle
    },
    axis: {
      x: {
        label: 'Year',
        tick: {
          fit: true,
        }
      },
      y: {
        label: 'Age'
      }
    }
  })
}

// var prepareData = function(serverResponse, chartType){
//   // serverResponse.sort(function(a, b){
//   //   return b.amount - a.amount;
//   // })
//   // var nestedArray = []
//   // serverResponse.forEach(function(element){
//   //   var label = element.label;
//   //   var amount = element.amount;
//   //   nestedArray.push([label, amount]);
//   // })
//   // var series = []

//   // if (chartType === 'pie') {
//   //   series = nestedArray.slice(0, 10); // use a variable that slices the interesting bit of the data. for education rate of women, you'd want to look at the last 10.
//   //   var other = 0;
//   //   for (var i = 10; i < nestedArray.length; i++) {
//   //     other += nestedArray[i][1];
//   //   }
//   //   series.push([String(nestedArray.length - 10) + " Others", Math.round(other, 2)]) // this math might hcange slightly depending on the slicing above
//   // } else if (chartType === 'bar'){ // 'bar'
//   //   series = nestedArray.slice(0, 10); // another dependency on the above
//   // }
//   // else
//   if (chartType === 'scatter'){ // 'bar'
//     series = nestedArray; // another dependency on the above
//   }
//   console.log("this is the series!!!!!")
//   console.log(series)
//   return series;
// }

var renderDownloadButton = function(){
  $("#download-div").removeClass("hidden");
  downloadHandler();
}

var downloadHandler = function(){
  $("#download-div").on("submit", function(event){
    event.preventDefault();
    saveSvgAsPng(($("svg")[0]), "chartable-diagram.png")
  })
}

// $(document).ready(function(){
//   visFormHandler();
// });

// var visFormHandler = function(){
//   $("#vis-form").on("submit",function(event){
//     event.preventDefault();
//     var $form = $(this);
//     console.log($form.attr("url"));
//     var chartType = $(":selected")[2].value;
//     // var $aggregatorToAppend = $(":selected")[0].value;
//     // var $descriptorToAppend = $(":selected")[1].value;
//     $request = $.ajax({
//       url: $form.attr("url"),
//       data: $form.serialize(),
//       method: $form.attr("method")
//     })
//     $request.done(function(serverResponse){
//       $("#chart").empty();
//       var dataTitle = serverResponse[1].dataset_title
//       var subTitle = serverResponse[1].subtitle
//       var chartTitle = [dataTitle,subTitle]
//       ///// chartData
//       var chartData = prepareData(serverResponse[0], chartType);
//       if(chartType === "bar" || chartType === "pie"){
//         produceChart(chartData, chartType, chartTitle);
//       }
//       else {
//         console.log("testing our new method")
//         var sortedScatterData = prepareScatterData(serverResponse[0])
//         produceChart(sortedScatterData, chartType, chartTitle);
//       }
//       renderDownloadButton();
//     })
//   })
// }

// var prepareScatterData = function(data){
//   console.log("this is the data passed into our brand new function")
//   console.log(data)
//   data.sort(function(a, b) {
//     return a.year - b.year;
//   })
//   return data
// }

// var produceChart = function(data, type, chartTitle){
//   console.log("THIS IS THE DATA passed into the produceChart")
//   console.log(data)
//   if (type === "pie") {
//     renderPieChart(data, chartTitle);
//   } else if (type === "bar") {
//     renderBarChart(data, chartTitle);
//   }
//   else {
//    return renderScatterPlot(data, chartTitle);
//   }
// }

// var renderPieChart = function(data, chartTitle) {
//   c3.generate({
//       data: {
//         columns: data,
//         type:'pie'
//       },
//       pie: {
//         label: {
//           format: function (value, ratio, id) {
//             return d3.format('$')(value)+"M"; // this should be a 'prefix' variable and a units variable
//           }
//         }
//       },
//       title: {
//        text: chartTitle[0] + " - " + chartTitle[1]
//      }
//    });
// }

// var renderBarChart = function(data, chartTitle) {
//   c3.generate({
//     data: {
//       columns: data,
//       type : 'bar'
//     },
//     axis: {
//       y: {
//         label:'In Millions' // this should be a variable
//       }
//     },
//     title: {
//       text: chartTitle[0] + " - " + chartTitle[1]
//     }
//   });
// }

// var renderScatterPlot = function(data, chartTitle) {
//   console.log("THIS IS THE DATA passed into the renderScatterPlot")
//   console.log(data)

//   var scatterplotColumns = scatterPlotCreateColumns(data);

//   // maps each group's name to the label series. eg:
//   // {
//   //    "Male": "years_x",
//   //    "Female": "years_x"
//   //    "Both Sexes": "years_x"
//   // }
//   var labelData = {};
//   for(i = 1; i < scatterplotColumns.length; i++) {
//     labelData[scatterplotColumns[i][0]] = scatterplotColumns[0][0];
//   }
//   console.log("this is what we really really really want")
//   console.log(scatterplotColumns)
//   console.log("this is the label data")
//   console.log(labelData)


//   c3.generate({
//     data: {
//       xsort: false,
//       xs: labelData,
//       columns: scatterplotColumns,
//       type: 'scatter'
//     },
//     title: {
//       text:  chartTitle[0] + " - " + chartTitle[1]
//     },
//     axis: {
//       x: {
//         label: 'Year',
//         tick: {
//           fit: true,
//         }
//       },
//       y: {
//         label: 'Age'
//       }
//     }
//   })
// }



// var prepareData = function(serverResponse, chartType){
//   serverResponse.sort(function(a, b){
//     return b.amount - a.amount;
//   })
//   var nestedArray = []
//   serverResponse.forEach(function(element){
//     var label = element.label;
//     var amount = element.amount;
//     nestedArray.push([label, amount]);
//   })
//   var series = []

//   if (chartType === 'pie') {
//     series = nestedArray.slice(0, 10); // use a variable that slices the interesting bit of the data. for education rate of women, you'd want to look at the last 10.
//     var other = 0;
//     for (var i = 10; i < nestedArray.length; i++) {
//       other += nestedArray[i][1];
//     }
//     series.push([String(nestedArray.length - 10) + " Others", Math.round(other, 2)]) // this math might hcange slightly depending on the slicing above
//   } else if (chartType === 'bar'){ // 'bar'
//     series = nestedArray.slice(0, 10); // another dependency on the above
//   }
//   else if (chartType === 'scatter'){ // 'bar'
//     series = nestedArray; // another dependency on the above
//   }
//   return series;
// }


// //create columns for scatter plot
// // returns all unique labels in an array as a nested array
// var removeDuplicates = function(labels){
//   return labels.filter(function(label, index, self){
//     return self.indexOf(label) == index;
//   })
// }

// // this returns the groups for example, ["White", "Black", "All Races"]
// var scatterGroups = function(data){
//   var allLabels = []
//   data.forEach(function(row){
//     allLabels.push(row.label)
//   })
//   return removeDuplicates(allLabels)
// }

// var nestedColumns = function(uniqueArrayOfColumns){
//   return uniqueArrayOfColumns.map(function(label){
//     return [label]
//   })
// }

// // this is the nested array C3 generator needs for scatterplot.
// // [["White", 81, 80, 79]
// // ["BLack", 79, 78, 76]
// // ["All races", 81, 80, 79]]
// var scatterPlotCreateColumns = function(data){
//   var scatterLabels = nestedColumns(scatterGroups(data))
//   var yearArray = ['years_x'];
//   data.forEach(function(row){
//     scatterLabels.forEach(function(labelArray){
//       if(row["label"] === labelArray[0]){
//         labelArray.push(row["amount"])
//       }
//     })
//     if (yearArray[yearArray.length - 1] !== row["year"]) {
//       yearArray.push(row["year"])
//     }
//   })
//   console.log('YEAR ARRAY!!!', yearArray)
//   scatterLabels.unshift(yearArray);

//   console.log("these are the scatter labels!")
//   console.log(scatterLabels)
//   return scatterLabels
// }

// // [{label: "Black", amount: 32.9}, {label: "Black", amount: 32.2}, {label: "Black", amount: 32.5}, {label: "White", amount: 78.0}, {label: "White", amount: 79.1}, {label: "White", amount: 79.1}, {label: "White", amount: 79.1}, {label: "White", amount: 79.0}, {label: "White", amount: 78.9}, {label: "White", amount: 78.8}, {label: "White", amount: 78.5}]

// var renderDownloadButton = function(){
//   $("#download-div").removeClass("hidden");
//   downloadHandler();
// }

// var downloadHandler = function(){
//   $("#download-div").on("submit", function(event){
//     event.preventDefault();
//     saveSvgAsPng(($("svg")[0]), "chartable-diagram.png")
//   })
// }
