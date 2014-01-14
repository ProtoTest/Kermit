window.onload=function(){
  var tfrow = document.getElementById('tfhover').rows.length;
  var tbRow=[];
  for (var i=1;i<tfrow;i++) {
    tbRow[i]=document.getElementById('tfhover').rows[i];
    tbRow[i].onmouseover = function(){
      this.style.backgroundColor = '#ffffff';
    };
    tbRow[i].onmouseout = function() {
      this.style.backgroundColor = '#d4e3e5';
    };
  }

  var margin = {top: 25, right: 20, bottom: 40, left: 50},
    width = (screen.width*.9)/2 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;
  var x = d3.time.scale()
      .range([0, width]);
  var y = d3.scale.linear()
      .range([height, 0]);
  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom");
  var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left");
  var cpu = $('#tfhover td:nth-child(4)').map(function() { return parseInt($(this).text());}).get()
  var memory = $('#tfhover td:nth-child(3)').map(function() { return parseFloat($(this).text());}).get()
  var line = d3.svg.line().x(function(d) { return x(d[0]); })
            .y(function(d, i) { 
                if (i<4) {
                  return y(d[1]);
                } else {
                  sum = _.reduce(cpu.slice(i-4,i+1), function(memo, num){ if (isNaN(num)) { return memo; } else { return memo + num; } }, 0);
                }
                console.log(sum);
                return y(sum / 5);

              });

  var svg = d3.select("body").select("#chartarea").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  parseTime = d3.time.format("%H.%M.%S").parse;
  var time = $('#tfhover td:nth-child(5)').map(function() { return parseTime($(this).text().match(/\d+\.\d+\.\d+/g)[1]);}).get()
  var data = _.zip(time,cpu)
  x.domain(d3.extent(data, function(d) { return d[0]; }));
  y.domain(d3.extent(data, function(d) { return d[1]; }));

  svg.append("g")
       .attr("class", "x axis")
       .attr("transform", "translate(0," + height + ")")
       .call(xAxis);
  svg.append("g")
       .attr("class", "y axis")
       .call(yAxis);
  svg.append("text")
       .attr("transform", "rotate(-90)")
       .attr("y", 0-margin.left)
       .attr("x", -height/2 - margin.top)
       .attr("dy", ".71em")
       .text("CPU % Used");
  svg.append("text")
       .attr("y", height+margin.top)
       .attr("x", width/2)
       .attr("dy", ".71em")
       .text("Time");
  svg.append("text")
       .attr("x", width/2)
       .text("CPU Usage");
  svg.append("path")
       .datum(data)
       .attr("class", "line")
       .attr("d", line);
  var line2 = d3.svg.line().x(function(d) { return x(d[0]); })
            .y(function(d) { console.log(y2(d[1])); return y2(d[1]); });
  var svg2 = d3.select("body").select("#chartarea2").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  var data2 = _.zip(time,memory)
  y2 = d3.scale.linear()
          .range([height, 0]);
  y2.domain(d3.extent(data2, function(d) { return d[1]; }));
  var yAxis2 = d3.svg.axis()
      .scale(y2)
      .orient("left");
  svg2.append("g")
       .attr("class", "x axis")
       .attr("transform", "translate(0," + height + ")")
       .call(xAxis);
  svg2.append("g")
       .attr("class", "y axis")
       .call(yAxis2);
  svg2.append("text")
       .attr("transform", "rotate(-90)")
       .attr("y", 0-margin.left)
       .attr("x", -height/2 - margin.top)
       .attr("dy", ".71em")
       .text("Memory Used (GB)");
  svg2.append("text")
       .attr("y", height+margin.top)
       .attr("x", width/2)
       .attr("dy", ".71em")
       .text("Time");
  svg2.append("text")
       .attr("x", width/2)
       .text("Memory Usage");
  svg2.append("path")
       .datum(data2)
       .attr("class", "line")
       .attr("d", line2);

};