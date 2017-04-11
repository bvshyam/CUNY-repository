var dataset = [ 5, 10, 15, 20, 25 ];

d3.select("body")
        .append("p")
        .text("New paragraph!");

d3.select("body").selectAll("p")
        .data(dataset)
        .enter()
        .append("p")
        .text(function(d) { return d+5; })
        .style("color", "red");

//

d3.csv("food.csv", function(data){ console.log(data);});

var dataset; //Declare global var
d3.csv("food.csv", function(data) {
//Hand CSV data off to global var,
//so it's accessible later.
dataset = data;
//Call some other functions that
//generate your visualization, e.g.:
//generateVisualization();
// makeAwesomeCharts();
// makeEvenAwesomerCharts();
// thankAwardsCommittee();
});
