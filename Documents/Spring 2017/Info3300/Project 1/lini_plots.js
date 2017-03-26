// script for dot plot

var svg = d3.select("#population_pickup");
svg.append("line")
.style("stroke","black")
.attr("x1", 50)
.attr("y1", 350)
.attr("x2", 350)
.attr("y2", 350);
svg.append("text")
.text("population")
.attr("x",355)
.attr("y",350)
.attr("font-size",10);
svg.append("line")
.style("stroke","black")
.attr("x1", 50)
.attr("y1", 350)
.attr("x2", 50)
.attr("y2", 50);
svg.append("text")
.text("Uber Pickup Amount")
.attr("x",50)
.attr("y",40)
.attr("font-size",10);

//compare pickup amount to area
var svg2 = d3.select("#area_pickup");
svg2.append("line")
.style("stroke","black")
.attr("x1", 50)
.attr("y1", 350)
.attr("x2", 350)
.attr("y2", 350);
svg2.append("text")
.text("Land area(square miles)")
.attr("x",290)
.attr("y",360)
.attr("font-size",10);
svg2.append("line")
.style("stroke","black")
.attr("x1", 50)
.attr("y1", 350)
.attr("x2", 50)
.attr("y2", 50);
svg2.append("text")
.text("Uber Pickup Amount")
.attr("x",50)
.attr("y",40)
.attr("font-size",10);

//compare pickup amount to Wealth
var svg3 = d3.select("#wealth_pickup");
svg3.append("line")
.style("stroke","black")
.attr("x1", 50)
.attr("y1", 350)
.attr("x2", 350)
.attr("y2", 350);
svg3.append("text")
.text("Avarage Income")
.attr("x",330)
.attr("y",360)
.attr("font-size",10);
svg3.append("line")
.style("stroke","black")
.attr("x1", 50)
.attr("y1", 350)
.attr("x2", 50)
.attr("y2", 50);
svg3.append("text")
.text("Uber Pickup Amount")
.attr("x",50)
.attr("y",40)
.attr("font-size",10);
// Define variables outside the scope of the callback function.
var boroughData;

// This function will be applied to all rows. Select three columns, change names, and convert strings to numbers.
function parseLine (line) {
	return {
		Borough: line["BoroughName"],
		Pickup: Number(line["UberPickup"]),
		PickupPercent: Number(line["PickupPercent"]),
		Wealth: Number(line["MeanIncome"]),
		Population: Number(line["Population"]),
		LandArea: Number(line["LandArea"])
	};
}

d3.tsv("borough.tsv", parseLine, function (error, data) {
	boroughData = data;
	var popExtent = d3.extent(boroughData,
		function (d) { return d.Population; });

	var popScale = d3.scaleLog()
	.domain(popExtent)
	.range([100, 300]);

	var wealthExtent = d3.extent(boroughData,
		function (d) { return d.Wealth; });

	var wealthScale = d3.scaleLog()
	.domain(wealthExtent)
	.range([100, 300]);

	var areaExtent = d3.extent(boroughData,
		function (d) { return d.LandArea; });

	var areaScale = d3.scaleLog()
	.domain(areaExtent)
	.range([100, 300]);

	var pickupExtent = d3.extent(boroughData,
		function (d) { return d.Pickup; });

	var pickupScale = d3.scaleLog()
	.domain(pickupExtent)
	.range([300, 100]);


	popCompareData = boroughData.filter(function (d) { return d.Population && d.Pickup; });



	popCompareData.forEach(function (borough) {

		svg.append("circle")
		.attr("cx", popScale(borough.Population))
		.attr("cy", pickupScale(borough.Pickup))
		.attr("r", 10)
		.style("opacity", 0.3)
		});


	popCompareData.forEach(function (borough) {
		svg.append("text")
		.text(borough.Borough)
		.attr("x",popScale(borough.Population))
		.attr("y",pickupScale(borough.Pickup))
		.attr("font-size",10);
		});

		wealthCompareData = boroughData.filter(function (d) { return d.Wealth && d.Pickup; });

		wealthCompareData.forEach(function (borough) {

			svg3.append("circle")
			.attr("cx", wealthScale(borough.Wealth))
			.attr("cy", pickupScale(borough.Pickup))
			.attr("r", 10)
			.style("opacity", 0.3)
			});


		wealthCompareData.forEach(function (borough) {
			svg3.append("text")
			.text(borough.Borough)
			.attr("x",wealthScale(borough.Wealth))
			.attr("y",pickupScale(borough.Pickup))
			.attr("font-size",10);
			});

			areaCompareData = boroughData.filter(function (d) { return d.LandArea && d.Pickup; });

			areaCompareData.forEach(function (borough) {

				svg2.append("circle")
				.attr("cx", areaScale(borough.LandArea))
				.attr("cy", pickupScale(borough.Pickup))
				.attr("r", 10)
				.style("opacity", 0.3)
				});


			areaCompareData.forEach(function (borough) {
				svg2.append("text")
				.text(borough.Borough)
				.attr("x",areaScale(borough.LandArea))
				.attr("y",pickupScale(borough.Pickup))
				.attr("font-size",10);
				});
	});
