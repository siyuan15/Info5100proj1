// script for line plot
var svgPerDay = d3.select("#avgPickupPerDay");

// add scale data and axis
var dateScale = d3.scaleTime().domain([new Date("2014-07-01"), new Date("2014-09-30")]).range([0, 800]);
var dateAxis = d3.axisBottom(dateScale).ticks(13).tickFormat(d3.timeFormat("%a %d-%b-%y"));
var pickupScale = d3.scaleLinear().domain([0,65000]).range([350, 0]);
var pickupAxis = d3.axisLeft(pickupScale);

// use the theme color of each company to draw the corresponding line
var companyColor = ["#FF00BF","#000"];

var linePlot = svgPerDay.append("g").attr("transform", "translate(0,0)");
linePlot.append("g").call(dateAxis).attr("transform", "translate(0,350)");
linePlot.append("g").call(pickupAxis).attr("transform", "translate(0,0)");
linePlot.append("text").attr("transform", "translate(-50, -30)").text("Average pickup per day")

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
    .attr("stroke-width", "2")
    .attr("fill", "none");
}


// script for heat map
var svgPerHour = d3.select("#avgPickupPerHour");
var weekday = ["0" ,"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
var colors = ['#ffffcc','#d9f0a3','#addd8e','#78c679','#31a354','#006837'];

// add scale data and axis
var hourScale = d3.scaleLinear().domain([0,24]).range([0, 900]);
var hourAxis = d3.axisBottom(hourScale).ticks(23);
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
