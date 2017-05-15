
showchart = function(){

//http://stackoverflow.com/questions/10615290/select-data-from-a-csv-before-loading-it-with-javascript-d3-library

var svg = d3.select("svg"),
    width = +svg.attr("width"),
    height = +svg.attr("height"),
    g = svg.append("g").attr("transform", "translate(" + (width / 2 + 40) + "," + (height / 2 + 90) + ")");

var stratify = d3.stratify()
    .parentId(function(d) { return d.id.substring(0, d.id.lastIndexOf(".")); });

var tree = d3.tree()
    .size([360, 500])
    .separation(function(a, b) { return (a.parent == b.parent ? 1 : 2) / a.depth; });

      d3.csv("all_cars_data_tree.csv", function(error, data) {

    data = data.filter(function(row) {
        return row['Car_Type'] == 'Subcompact Cars' || row['Car_Type'] == 'Compact Cars' || row['Car_Type'] == 'Midsize Cars'|| row['Car_Type'] == 'Large Cars';
//        return row['Car_Type'] == 'Subcompact Cars' || row['Car_Type'] == 'Compact Cars' || row['Car_Type'] == 'Midsize Cars'|| row['Car_Type'] == 'Large Cars';
    })

  // vis.datum(csv).call(chart);



        _.each(data, function(element, index, list){
            element.pop = +element.pop;
        });

        //*************************************************
        // THE FUNCTION
        //*************************************************
        function genJSON(csvData, groups) {

          var genGroups = function(data) {
            return _.map(data, function(element, index) {
              return { name : index, children : element };
            });
          };

          var nest = function(node, curIndex) {
            if (curIndex === 0) {
              node.children = genGroups(_.groupBy(csvData, groups[0]));
              _.each(node.children, function (child) {
                nest(child, curIndex + 1);
              });
            }
            else {
              if (curIndex < groups.length) {
                node.children = genGroups(
                  _.groupBy(node.children, groups[curIndex])
                );
                _.each(node.children, function (child) {
                  nest(child, curIndex + 1);
                });
              }
            }
            return node;
          };
          return nest({}, 0);
        }


        //*************************************************
        // CALL THE FUNCTION
        //*************************************************
        //console.log(option1.options[option1.selectedIndex].value,option2.options[option2.selectedIndex].value);
        var treeData_new = genJSON(data, ['Car_Type','make']);

             // console.log(treeData_new);


// d3.json("flare.json", function(error, data) {
//   if (error) throw error;

  //var root = tree(stratify(data));

var root = d3.hierarchy(treeData_new);
tree(root);


  var link = g.selectAll(".link")
    .data(root.descendants().slice(1))
    .enter().append("path")
      .attr("class", "link")
      .attr("d", function(d) {
        return "M" + project(d.x, d.y)
            + "C" + project(d.x, (d.y + d.parent.y) / 2)
            + " " + project(d.parent.x, (d.y + d.parent.y) / 2)
            + " " + project(d.parent.x, d.parent.y);
      });

  var node = g.selectAll(".node")
    .data(root.descendants())
    .enter().append("g")
      .attr("class", function(d) { return "node" + (d.children ? " node--internal" : " node--leaf"); })
      .attr("transform", function(d) { return "translate(" + project(d.x, d.y) + ")"; });

  node.append("circle")
      .attr("r", 2.5);

  node.append("text")
      .attr("dy", ".31em")
      .attr("x", function(d) { return d.x < 180 === !d.children ? 6 : -6; })
      .style("text-anchor", function(d) { return d.x < 180 === !d.children ? "start" : "end"; })
      .attr("transform", function(d) { return "rotate(" + (d.x < 180 ? d.x - 90 : d.x + 90) + ")"; })
      .text(function(d) { return d.data.name; });
        // return d.id.substring(d.id.lastIndexOf(".") + 1); 

        });
//});

function project(x, y) {
  var angle = (x - 90) / 180 * Math.PI, radius = y;
  return [radius * Math.cos(angle), radius * Math.sin(angle)];
}

}