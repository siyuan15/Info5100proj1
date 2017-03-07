// script for line plot
var svgPerDay = d3.select("#avgPickupPerDay");

// create scale for data and axes
var dateScale = d3.scaleTime().domain([new Date("2014-07-01"), new Date("2014-09-30")]).range([0, 700]);
var dateAxis = d3.axisBottom(dateScale).ticks(13).tickFormat(d3.timeFormat("%a %d-%b-%y"));
var pickupScale = d3.scaleLinear().domain([0,65000]).range([350, 0]);
var pickupAxis = d3.axisLeft(pickupScale);

// use the theme color of each company to draw the corresponding line
var companyColor = ["#8ADAC1","#006d2c"];

//important dates for Uber and Lyft
var importantDates = [{"index": "1", "Date": "2014-07-07", "Name": "Uber", "Event1": "UbeX 20%", "Event2": "Price Cut"},
                      {"index": "2", "Date": "2014-07-25", "Name": "Lyft", "Event1": "Lyft Launch", "Event2": "in NYC"},
                      {"index": "3", "Date": "2014-09-05", "Name": "Uber", "Event1": "Third Anniversary", "Event2": "of UberX in NYC"}];
// add axes to svg and tilt the ticks on x-axis to save room for label
var linePlot = svgPerDay.append("g").attr("transform", "translate(0,0)");
linePlot.append("g").call(dateAxis)
  .attr("transform", "translate(0,350)")
  .selectAll("text")
    .style("text-anchor", "end")
    .attr("dx", "-.8em")
    .attr("dy", ".15em")
    .attr("transform", function(d) {
        return "rotate(-65)"
        });
linePlot.append("g").call(pickupAxis).attr("transform", "translate(0,0)");
linePlot.append("text").attr("transform", "translate(-50, -30)")
  .attr("font-family", "sans-serif")
  .text("Average pickup per day");
linePlot.append("text").attr("transform", "translate(710, 360)")
  .attr("font-family", "sans-serif")
  .text("Date");

// add legend to graph
linePlot.append("line")
  .attr("x1", 640)
  .attr("y1", -30)
  .attr("x2", 670)
  .attr("y2", -30)
  .attr("stroke-width", "3")
  .attr("stroke", "#006d2c");

linePlot.append("line")
  .attr("x1", 640)
  .attr("y1", 0)
  .attr("x2", 670)
  .attr("y2", 0)
  .attr("stroke-width", "3")
  .attr("stroke", "#8ADAC1");

linePlot.append("text")
  .attr("transform", "translate(675, -25)")
  .attr("font-family", "sans-serif")
  .text("Uber");

linePlot.append("text")
  .attr("transform", "translate(675, 5)")
  .attr("font-family", "sans-serif")
  .text("Lyft");

// define the line for Lyft
var generateLine = d3.line()
.x(function (l) { return dateScale(l.Date); })
.y(function (l) { return pickupScale(l.PickupPerDay); });

// Define variables outside the scope of the callback function.
var rawData, nestedData;
var company;

// Select Lyft, Uber, and Green Taxis and convert their value to numbers
function parseLine (d) {
    d.Date = new Date(d.Date);
    d.PickupPerDay = +d.PickupPerDay;
    return d;
}

d3.csv("finalTaxiAggregate.csv", parseLine, function (error, data) {
  //rawData = data;

  nestedData = d3.nest()
  .key(function(d) {return d.index;})
  .key(function (d) { return d.CompanyName; })
  .entries(data);

  showTrends(nestedData[0].values);
  importantDates.forEach(markDates);
});

function showTrends(lineData) {
  // Create or modify paths for each sector
   var paths = linePlot.selectAll("path.lineGraph").data(lineData);
   paths.enter()
    .append("path")
    .merge(paths)
    .attr("class", "lineGraph")
    .attr("d", function (line) {
      return generateLine(line.values)})
    .style("stroke", function(line, i) {
        return companyColor[i];
    })
    .attr("stroke-width", "3")
    .attr("fill", "none");
}

// // mark interesting dates on each line
// var markDates = svgPerDay.append("g").attr("transform", "translate(0,0)");
// markDates.append
function markDates (data) {
  data.Date = new Date(data.Date);
  var dateIndex = +data.index;
  var xPosition = dateScale(data.Date);
  var themeColor = function (){
    if (data.Name == "Uber") {
      return "#006d2c";
    }
    return "#8ADAC1";
  };

  var mDates = linePlot.append("g")
  mDates.append("line")
    .attr("x1", xPosition)
    .attr("y1", 150 / dateIndex + 6)
    .attr("x2", xPosition)
    .attr("y2", 350)
    .attr("stroke-dasharray", ("5, 5"))
    .attr("stroke-width", 2)
    .attr("stroke", themeColor);

  mDates.append("circle")
    .attr("cx", xPosition)
    .attr("cy", 150 / dateIndex)
    .attr("r", 6)
    .attr("stroke", themeColor)
    .attr("fill", "none")
    .attr("stroke-width", 2);

  mDates.append("circle")
    .attr("cx", xPosition)
    .attr("cy", 150 / dateIndex)
    .attr("r", 2)
    .attr("stroke", themeColor)
    .attr("fill", themeColor)
    .attr("stroke-width", 2);

  mDates.append("text")
    .attr("x", xPosition - 15 * dateIndex)
    .attr("y", 150 / dateIndex - 30)
    .attr("font-family", "sans-serif")
    .attr("font-size", 13)
    .text(data.Event1)

  mDates.append("text")
    .attr("x", xPosition - 15 * dateIndex)
    .attr("y", 150 / dateIndex - 15)
    .attr("font-family", "sans-serif")
    .attr("font-size", 13)
    .text(data.Event2);
}

// script for heat map
var svgPerHour = d3.select("#avgPickupPerHour");
var times = ["12a", "1a", "2a", "3a", "4a", "5a", "6a", "7a", "8a", "9a", "10a", "11a", "12p",
             "1p", "2p", "3p", "4p", "5p", "6p", "7p", "8p", "9p", "10p", "11p", "12a"];
var weekday = ["0" ,"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
var colors = ['#ffffcc','#d9f0a3','#addd8e','#78c679','#31a354','#006837'];

// add scale data and axis
var hourScale = d3.scaleLinear().domain([0,24]).range([0, 900]);
var hourAxis = d3.axisBottom(hourScale).ticks(23).tickFormat(function(d,i) {return times[i]});
var weekScale = d3.scaleLinear().domain([0, 8]).range([350, 0]);
var weekAxis = d3.axisLeft(weekScale).ticks(7)
                 .tickFormat(function(d, i) {return weekday[i]});

// draw axis on svg
var squarePlot = svgPerHour.append("g").attr("transform", "translate(10,0)");
squarePlot.append("g").call(hourAxis).attr("transform", "translate(10,350)");
squarePlot.append("g").call(weekAxis).attr("transform", "translate(10,0)");

function parseRow (d) {
  d.Weekday = +d.Weekday;
  d.Hour = +d.Hour;
  d.Uber = +d.Uber;
  return d;
}

var perHour;

d3.csv("UberAggPerHour.csv", parseRow, function(error, data) {
  perHour = data;
  showPlot();
})
var i = 0;
function showPlot(){
  perHour.forEach(function(d) {
    squarePlot.append("circle")
      .attr("cx", hourScale(d.Hour) + 30)
      .attr("cy", weekScale(d.Weekday))
      .attr("r", function() {
        return Math.sqrt(d.Uber / 120) * 4;
      })
      .attr("fill", "#006d2c")
      .attr("opacity", function() {
        if (d.Uber/2000 <= 0.4) {
          return d.Uber/2000 + 0.2;
        }
        return d.Uber/2000 + 0.1;
      });
  })
}

// add legend to graph
squarePlot.append("text")
  .attr("transform", "translate(-20, -20)")
  .attr("font-family", "sans-serif")
  .attr("font-size", 15)
  .text("Weekday");

squarePlot.append("text")
  .attr("transform", "translate(930, 355)")
  .attr("font-family", "sans-serif")
  .attr("font-size", 15)
  .text("Hours");

squarePlot.append("circle")
  .attr("cx", 150)
  .attr("cy", 430)
  .attr("r", 5)
  .attr("fill", "#006d2c")
  .attr("opacity", 0.3);

squarePlot.append("line")
  .attr("x1", 160)
  .attr("y1", 430)
  .attr("x2", 200)
  .attr("y2", 430)
  .attr("stroke-dasharray", ("5, 5"))
  .attr("stroke-width", 3)
  .attr("stroke", "#006d2c")
  .attr("opacity", 0.3);

squarePlot.append("circle")
  .attr("cx", 380)
  .attr("cy", 430)
  .attr("r", 10)
  .attr("fill", "#006d2c")
  .attr("opacity", 0.7);

squarePlot.append("line")
  .attr("x1", 395)
  .attr("y1", 430)
  .attr("x2", 435)
  .attr("y2", 430)
  .attr("stroke-dasharray", ("5, 5"))
  .attr("stroke-width", 3)
  .attr("stroke", "#006d2c");

squarePlot.append("circle")
  .attr("cx", 630)
  .attr("cy", 430)
  .attr("r", 16)
  .attr("fill", "#006d2c")
  .attr("opacity", 1);

squarePlot.append("line")
  .attr("x1", 650)
  .attr("y1", 430)
  .attr("x2", 690)
  .attr("y2", 430)
  .attr("stroke-dasharray", ("5, 5"))
  .attr("stroke-width", 3)
  .attr("stroke", "#006d2c");

squarePlot.append("text")
  .attr("transform", "translate(210, 435)")
  .attr("font-family", "sans-serif")
  .attr("font-size", 20)
  .text("120");

squarePlot.append("text")
  .attr("transform", "translate(445, 437)")
  .attr("font-family", "sans-serif")
  .attr("font-size", 25)
  .text("1000");

squarePlot.append("text")
  .attr("transform", "translate(700, 437)")
  .attr("font-family", "sans-serif")
  .attr("font-size", 25)
  .text("2400");
