ukcoursemap.graph = {

  setup: function(){

    var width = $("#graph").width(),
        height = $("#graph").height(),
        padding = 1.5,
        diameter = Math.min(height, width) * 0.8,
        outerRadius = Math.min(height, width) * 0.45,
        jobRadius = 15;

    var jsonCourses;

    var pack = d3.layout.pack()
          .size([diameter, diameter])
          .value(function(d) { return d.size; })
          .padding(padding)
          .children(function(d) {
            return d.categories ? d.categories : d.sub_categories;
          });


    // -- Add SVG --

    var svg = d3.select("#graph").insert("svg:svg")
          .attr("width", width)
          .attr("height", height);


    // -- Add grid --

    var gridWidth = width-50,
        gridHeight = height,
        gridLines = [];

    for (var i = 0; i < gridWidth; i = i + 20) {
      gridLines.push({"x1": i, "x2": i, "y1": 0, "y2": gridHeight});
    }

    for (var i = 0; i < gridHeight; i = i + 20) {
      gridLines.push({"x1": 0, "x2": gridWidth, "y1": i, "y2": i});
    }

    svg.append("svg:g")
      .selectAll("line")
      .data(gridLines)
      .enter().append("svg:line")
      .attr("x1", function(d) { return d.x1; })
      .attr("y1", function(d) { return d.y1; })
      .attr("x2", function(d) { return d.x2; })
      .attr("y2", function(d) { return d.y2; })
      .style("stroke", "rgb(212,212,212)");


    // -- Add courses --

    var vis = svg.append("svg:g")
          .attr("transform",
                "translate(" + (width - diameter) / 2 + "," +
                (height - diameter) / 2 + ")");

    var index = 0;

    d3.json("/all_data.json", function(data) {

      jsonCourses = data;

      var nodesData = pack.nodes(jsonCourses);

      vis.selectAll("circle")
        .data(nodesData)
        .enter().append("svg:circle")
        .attr("id", function(d) {
          var type = d.sub_categories ? "category" : "sub_category";
          return type + "_" + d.id;
        })
        .attr("class", function(d) {
          var classname = d.sub_categories ? "category" : "sub_category";
          if( d.sub_categories ){
            return classname + " gradient_" + index++;
          } else if (d.parent) {
            return classname;
          } else {
            return "root";
          }
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
          return d.sub_categories ? zoomIn(d) : null;
        })
        .on("mouseover", function(d) {
          $("div#info").text(d.name);
          $("circle[parent=" + d.id + "]")
            .css("opacity", 1);
          d3.json("/jobs.json?course=" + d.id, function(data) {
            var jobs = findTargets(data);
            vis.selectAll("line").data(jobs).enter()
              .append("svg:line")
              .attr("percent", function(d) { return d.percent; })
              .attr("x1", d.x)
              .attr("y1", d.y)
              .attr("x2", function(d) { return d.targetX; })
              .attr("y2", function(d) { return d.targetY; })
              .style("stroke-width", function(d) { return d.percent; });
          });
        })
        .on("mouseout", function(d) {
          $("div#info").text("");
          $("circle[parent=" + d.id + "]")
            .css("opacity", 0);
          vis.selectAll("line").remove();
        });
    });

    function findTargets(arr) {
      for (var elem in arr) {
        var target = $("circle#" + arr[elem].target).get(0);
        arr[elem].targetX = target.cx;
        arr[elem].targetY = target.cy;
      }
      return arr;
    }


    // -- Add jobs --

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

      svg.append("svg:g").selectAll("circle")
        .data(jobs)
        .enter()
        .append("svg:circle")
        .attr("id", function(d) { return ("job_" + d.id); })
        .attr("title", function(d) { return d.title; })
        .attr("class", "job")
        .attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; })
        .attr("r", function(d) { return d.r; })
        .on("mouseover", function(d) {
          var elm = d3.select(this)[0];
          $("div#info").removeClass("hidden").text(d.title).css({
            top: $(elm).offset().top,
            left: $(elm).offset().left+50
          });
          d3.json("/courses.json?job=" + d.id, function(data) {
            var jobs = findTargets(data);
            vis.selectAll("line").data(jobs).enter()
              .append("svg:line")
              .attr("percent", function(d) { return d.percent; })
              .attr("x1", d.x)
              .attr("y1", d.y)
              .attr("x2", function(d) { return d.targetX; })
              .attr("y2", function(d) { return d.targetY; })
              .style("stroke-width", function(d) { return d.percent; });
          });
        })
        .on("mouseout", function(d) {
          $("div#info").text("").addClass("hidden");
          vis.selectAll("line").remove();
        });
    });


    // -- Zooming --
    var x = d3.scale.linear().range([0, diameter]),
        y = d3.scale.linear().range([0, diameter]);

    function zoomIn(node) {
      var k = diameter / node.r / 2;
      x.domain([node.x - node.r, node.x + node.r]);
      y.domain([node.y - node.r, node.y + node.r]);

      vis.selectAll("circle")
        .transition()
        .duration(1000)
        .style("opacity", function(d) {
          return d.parent && (d.parent.id == node.id) ? 1 : 0;
        })
        .attr("cx", function(d) { return x(d.x); })
        .attr("cy", function(d) { return y(d.y); })
        .attr("r", function(d) { d.origR = d.r; return k * d.r; });

      vis.selectAll("circle")
        .on("click", zoomOut) // FIXME: Should open pop-up
        .on("mouseover", function(d) {
          $("div#info").text(d.name);
        })
        .on("mouseout", function(d) {
          $("div#info").text("");
        });

      // FIXME
      // $("body").on("click", function() { return zoomOut(); });
      // d3.select(window).on("click", null);
    }

    function zoomOut() {
      vis.selectAll("circle")
        .transition()
        .duration(1000)
        .style("opacity", function(d) {
          return d.sub_categories ? 1 : 0;
        })
        .attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; })
        .attr("r", function(d) { return d.origR; });

      vis.selectAll("circle")
        .on("click", function(d) {
          return d.sub_categories ? zoomIn(d) : null;
        })
        .on("mouseover", function(d) {
          $("div#info").text(d.name);
          $("circle[parent=" + d.id + "]")
            .css("opacity", 1);
        })
        .on("mouseout", function(d) {
          $("div#info").text("");
          $("circle[parent=" + d.id + "]")
            .css("opacity", 0);
        });

      // FIXME
      // d3.select(window).on("click", null);
    }

  },

  filter: function(ids) {
    console.log("Hiding")
    console.log(ids)
    d3.select("#graph svg").selectAll("circle")
      .filter(function(d) {
        return $.inArray(d3.select(this).attr("id"), ids) >= 0;
      })
      .transition()
      .duration(800)
      .style("opacity", 0)
      .style("visibility", "hidden");
  }

};
