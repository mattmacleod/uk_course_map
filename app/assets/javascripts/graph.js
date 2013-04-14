var width = window.innerWidth * 0.99,
    height = window.innerHeight * 0.97,
    padding = 1.5,
    diameter = Math.min(height, width) * 0.8,
    outerRadius = Math.min(height, width) * 0.45,
    jobRadius = 15;

var node, root;

var pack = d3.layout.pack()
    .size([diameter, diameter])
    .value(function(d) { return d.size; })
    .padding(padding)
    .children(function(d) {
      if (d.categories != null)
        return d.categories;
      else
        return d.sub_categories;
    });


// -- Add SVG --

var vis = d3.select("body").insert("svg:svg")
    .attr("width", width)
    .attr("height", height)
  .append("svg:g")
    .attr("transform",
      "translate(" + (width - diameter) / 2 + "," +
        (height - diameter) / 2 + ")");

//for (var i = 0; i < width; i = i + 20) {
//    x1 = i;
//    x2 = x1 + 10;
//    vis.append("svg:line")
//    .attr("x1", x1)
//    .attr("x2", x2)
//    .attr("y1", 0)
//    .attr("y2", height)
//    .style("stroke", "rgb(212,212,212)");
//}

// -- Add courses --

d3.json("/all_data.json", function(data) {

  node = root = data;

  var nodes = pack.nodes(root);

  vis.selectAll("circle")
    .data(nodes)
    .enter().append("svg:circle")
      .attr("id", function(d) { return d.id; })
      .attr("class", function(d) {
        return d.sub_categories ? "category" : "sub_category";
      })
      .attr("cx", function(d) { return d.x; })
      .attr("cy", function(d) { return d.y; })
      .attr("r", function(d) { return d.r; })
      .attr("parent", function(d) {
        return d.parent? d.parent.id : null;
      })
      .style("opacity", function(d) {
        return d.sub_categories ? 1 : 0;
      })
      .on("click", function(d) {
        return zoom(node == d ? root : d);
      })
      .on("mouseover", function(d) {
        $("circle[parent=" + d.id + "]")
          .css("opacity", 1);
      })
      .on("mouseout", function(d) {
        $("circle[parent=" + d.id + "]")
          .css("opacity", 0);
      });

  d3.select(window).on("click", function() { zoom(root); });
});


// -- Add jobs --

var vis2 = d3.select("svg").append("svg:g");

d3.json("/jobs.json", function(data) {

  function onCircle(arr) {
    for (var i = 0; i < arr.length; i++) {
      var angle = (2 * Math.PI / arr.length) * i;
      arr[i].r = jobRadius;
      arr[i].x = width / 2 + outerRadius * Math.cos(angle);
      arr[i].y = height / 2 + outerRadius * Math.sin(angle);
    }
    return arr;
  }

  var jobs = onCircle(data);

  vis2.selectAll("circle").data(jobs)
    .enter().append("svg:circle")
      .attr("id", function(d) { return d.id; })
      .attr("title", function(d) { return d.title; })
      .attr("class", "job")
      .attr("cx", function(d) { return d.x; })
      .attr("cy", function(d) { return d.y; })
      .attr("r", function(d) { return d.r; });
});


// -- Zooming --
// FIXME: Doesn't work
var x = d3.scale.linear().range([0, diameter]),
    y = d3.scale.linear().range([0, diameter]);

function zoom(d, i) {
  var k = r / d.r / 2;
  x.domain([d.x - d.r, d.x + d.r]);
  y.domain([d.y - d.r, d.y + d.r]);

  var t = vis.transition()
      .duration(d3.event.altKey ? 7500 : 750);

  t.selectAll("circle")
      .attr("cx", function(d) { return x(d.x); })
      .attr("cy", function(d) { return y(d.y); })
      .attr("r", function(d) { return k * d.r; });
  node = d;
  d3.event.stopPropagation();
}

