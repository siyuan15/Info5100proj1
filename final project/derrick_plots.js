// script for NYC map

var svgMap = d3.select("#popularLoc");
var uberPickups = [[-73.715, 40.7],[-73.715, 40.5],[-74.4533, 40.4996]];
var highlightPoint = [[-73.976368, 40.758637]]

d3.csv("testData.csv", function (data) {

  data.forEach(function(d) {
    d.Lat = +d.Lat;
    d.Lon = +d.Lon;
  })

  uberPickups = data;

  var points = new Array(0);
  uberPickups.forEach(function(tree) {
    var a = [tree.Lon, tree.Lat];
    // a[1] = tree.species;
    points.push(a);
  });

  //Making the map
  d3.json("newyork.geojson", function (data) {

    var group = svgMap.selectAll("g")
      .data(data.features)
      .enter()
      .append("g")

    var projection = d3.geoMercator()
      .scale(150000)
      .center([-73.87, 40.76]);
    var path = d3.geoPath().projection(projection);

    var areas = group.append("path")
      .attr("d", path)
      .attr("class", "area")
      .attr("fill", "#238b45")

    //Making the circles
    var circles = svgMap.selectAll("circle").data(points);
    var highlights = svgMap.selectAll("circle").data(highlightPoint);

    circles.enter().append("circle")
      .attr("r", 3)
      .attr("cx", function(d) {
        return projection(d)[0]; })
      .attr("cy", function(d) {
        return projection(d)[1]; })
      .attr("fill", "#edf8e9")
      .attr("opacity", "0.05");

    highlights.enter().append("circle")
      .attr("r", 38)
      .attr("stroke", "#ffffcc")
      .attr("stroke-width", 3)
      .attr("fill", "none")
      .attr("cx", function(d) {
        return projection(d)[0]; })
      .attr("cy", function(d) {
        return projection(d)[1]; })
  });
});
