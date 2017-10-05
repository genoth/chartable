$(document).ready(function(){
  var url = document.URL;
  // if no query params
  if (url.includes('?')){
    var paramsObject = getAllUrlParams(url).aggregations.split("%20").join(" ")
    console.log(paramsObject)
    // URI.decode_www_form_component(s)
    var formUrl = pullFormUrl(url)
    $.ajax({
      url: formUrl + '/query',
      type: 'POST',
      async:false,
      data: paramsObject
    })
    .done(function() {
      console.log("success");
    })
    .fail(function() {
      console.log("error");
    })
    .always(function() {
      console.log("complete");
    });

  }
  else{
    visFormHandler();
  }
});

var getAllUrlParams =function(url) {

  // get query string from url (optional) or window
  var queryString = url ? url.split('?')[1] : window.location.search.slice(1);

  // we'll store the parameters here
  var obj = {};

  // if query string exists
  if (queryString) {

    // stuff after # is not part of query string, so get rid of it
    queryString = queryString.split('#')[0];

    // split our query string into its component parts
    var arr = queryString.split('&');

    for (var i=0; i<arr.length; i++) {
      // separate the keys and the values
      var a = arr[i].split('=');

      // in case params look like: list[]=thing1&list[]=thing2
      var paramNum = undefined;
      var paramName = a[0].replace(/\[\d*\]/, function(v) {
        paramNum = v.slice(1,-1);
        return '';
      });
      // set parameter value (use 'true' if empty)
      var paramValue = typeof(a[1])==='undefined' ? true : a[1];

      // (optional) keep case consistent
      paramName = paramName.toLowerCase();
      paramValue = paramValue.toLowerCase();

      // if parameter name already exists
      if (obj[paramName]) {
        // convert value to array (if still string)
        if (typeof obj[paramName] === 'string') {
          obj[paramName] = [obj[paramName]];
        }
        // if no array index number specified...
        if (typeof paramNum === 'undefined') {
          // put the value on the end of the array
          obj[paramName].push(paramValue);
        }
        // if array index number specified...
        else {
          // put the value at that index number
          obj[paramName][paramNum] = paramValue;
        }
      }
      // if param name doesn't exist yet, set it
      else {
        obj[paramName] = paramValue;
      }
    }
  }
  return obj;
}

var pullFormUrl = function(url){
  console.log("THIS IS THE URL FORMATTER")
  var paramsIndex = url.search('/datasets/')
  var urlParams = url.slice(paramsIndex)
  // gives /datasets/trump
  var formUrl = urlParams.slice(urlParams.indexOf('/'),urlParams.indexOf('?'))
  return formUrl
}

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
      var dataTitle = serverResponse[1].dataset_title
      var subTitle = serverResponse[1].subtitle
      var chartTitle = [dataTitle,subTitle]
      // var strongParams = serverResponse[2].strong_params
      // console.log(strongParams)
      ///// chartData
      var chartData = prepareData(serverResponse[0], chartType);
      if(chartType === "bar" || chartType === "pie"){
        produceChart(chartData, chartType, chartTitle);
      }
      else {
        console.log("testing our new method")
        var sortedScatterData = prepareScatterData(serverResponse[0])
        produceChart(sortedScatterData, chartType, chartTitle);
      }
      renderDownloadButton();
    })
  })
}


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

//RENDER RESET GRAPH TEST
// var urlFormatter = function(url){
//   console.log("THIS IS THE URL FORMATTER")
//   var paramsIndex = url.search('/datasets/')
//   var urlParams = url.slice(paramsIndex)
//   // gives /datasets/trump
//   var formUrl = urlParams.slice(urlParams.indexOf('/'),urlParams.indexOf('?'))
//   //gives thing=thing2&thing3=thing4
//   var formParams = urlParams.slice(urlParams.indexOf('?')+1)
//   var paramsArray = []
//   paramsArray.push("aggregation", "descriptor","chartKind","limit","order")

//   paramsArray.map(function(param){
//     console.log(param)
//     var paramsLocator = formParams.search(param)
//     var paramsRetrieveIndex = (param.length)*2+1
//     return console.log(formParams.slice(paramsLocator, paramsRetrieveLength))
//   })
//   return paramsArray
//   console.log(paramsArray)
// }
