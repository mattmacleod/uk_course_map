ukcoursemap.graph = {

  setup: function(){

    var $graph = $("#graph");

    var width = $graph.width(),
        height = $graph.height(),
        radius = Math.min(height, width) * 0.8;
        padding = 10;

    var x = d3.scale.linear().range([0, radius]),
        y = d3.scale.linear().range([0, radius]);

    var node, root;

    var pack = d3.layout.pack()
        .size([radius, radius])
        .value(function(d) { return d.size; })
        .padding(padding)
        .children(function(d) {
          if (d.categories != null)
            return d.categories;
          else
            return d.sub_categories;
        });

    var vis = d3.select("#graph").insert("svg:svg")
        .attr("width", width)
        .attr("height", height)
      .append("svg:g")
        .attr("transform",
          "translate(" + (width - radius) / 2 + "," +
            (height - radius) / 2 + ")");

    // d3.json("data/jobs.json", function(data) {
    // });

    //d3.json("http://uk_course_map.192.168.126.67.xip.io/all_data.json", function(data) {
    d3.json("/all_data.json", function(data) {

      console.log(data);
      node = root = data;

      var nodes = pack.nodes(root);
      console.log(root);

      var index = 0;

      vis.selectAll("circle")
        .data(nodes)
        .enter().append("svg:circle")
        .attr("id", function(d) { return d.name; })
        .attr("class", function(d) {
          var classname = d.sub_categories ? "category" : "sub_category";
          if( d.sub_categories ){
            return classname + " gradient_" + index++;
          } else {
            return classname;
          }
        })
        .attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; })
        .attr("r", function(d) { return d.r; })
        .style("opacity", function(d) {
          return d.parent == null ? 0 : 1;
        })
        .on("click", function(d) {
          return zoom(node == d ? root : d);
        });

      // vis.selectAll("text")
      //     .data(nodes)
      //   .enter().append("svg:text")
      //     .attr("class", function(d) {
      //       return d.children ? "parent" : "child";
      //     })
      //     .attr("x", function(d) { return d.x; })
      //     .attr("y", function(d) { return d.y; })
      //     .attr("dy", ".35em")
      //     .attr("text-anchor", "middle")
      //     .style("opacity", function(d) {
      //       return d.r > 20 ? 1 : 0;
      //     })
      //     .text(function(d) { return d.name; });

      d3.select(window).on("click", function() { zoom(root); });
    });

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

      // t.selectAll("text")
      //     .attr("x", function(d) { return x(d.x); })
      //     .attr("y", function(d) { return y(d.y); })
      //     .style("opacity", function(d) {
      //       return k * d.r > 20 ? 1 : 0;
      //     });

      node = d;
      d3.event.stopPropagation();
    }
  }

};
