var effortDistributionData = [
  {
    "source": "New Feature Development",
    "percentage": 22
  },
  {
    "source": "QA",
    "percentage": 44
  },
  {
    "source": "Bug Fixing",
    "percentage": 33
  }
];

var requirementDuration = [
  {
    "source": "FNDCAMP-8088",
    "duration": 10
  },
  {
    "source": "FNDCAMP-8087",
    "duration": 7
  },
  {
    "source": "FNDCAMP-8018",
    "duration": 13
  },
  {
    "source": "FNDCAMP-8087",
    "duration": 9
  }
];

var requirementEffort = [
  {
    "source": "FNDCAMP-8088",
    "effort": 43
  },
  {
    "source": "FNDCAMP-8087",
    "effort": 37
  },
  {
    "source": "FNDCAMP-8018",
    "effort": 64
  },
  {
    "source": "FNDCAMP-8087",
    "effort": 89
  }
];

var dailyEffortDistributionData = [
  {
    "day": "D1",
    "dev": 10,
    "qa": 4,
    "bug": 0,
    "req": 0
  },
  {
    "day": "D2",
    "dev": 10,
    "qa": 4,
    "bug": 0,
    "req": 0
  },
  {
    "day": "D3",
    "dev": 10,
    "qa": 4,
    "bug": 0,
    "req": 0
  },
  {
    "day": "D4",
    "dev": 10,
    "qa": 4,
    "bug": 0,
    "req": 0
  },
  {
    "day": "D5",
    "dev": 10,
    "qa": 4,
    "bug": 0,
    "req": 0
  },
  {
    "day": "D6",
    "dev": 10,
    "qa": 4,
    "bug": 0,
    "req": 0
  },
  {
    "day": "D7",
    "dev": 10,
    "qa": 4,
    "bug": 0,
    "req": 1
  },
  {
    "day": "D8",
    "dev": 8,
    "qa": 4,
    "bug": 0,
    "req": 1
  },
  {
    "day": "D9",
    "dev": 10,
    "qa": 4,
    "bug": 0,
    "req": 1
  },
  {
    "day": "D10",
    "dev": 10,
    "qa": 4,
    "bug": 9,
    "req": 2
  },
  {
    "day": "D11",
    "dev": 10,
    "qa": 4,
    "bug": 10,
    "req": 2
  },
  {
    "day": "D12",
    "dev": 10,
    "qa": 4,
    "bug": 20,
    "req": 3
  },
  {
    "day": "D13",
    "dev": 10,
    "qa": 4,
    "bug": 40,
    "req": 3
  },
  {
    "day": "D14",
    "dev": 10,
    "qa": 4,
    "bug": 30,
    "req": 3
  },
  {
    "day": "D15",
    "dev": 10,
    "qa": 4,
    "bug": 20,
    "req": 4
  },
];

function createDailyEffortDistributionChart(){
  $('#daily-effort-distribution-chart').kendoChart({
    theme: "kendo",
    chartArea:{
      background: "transparent"
    },
    title:{
      font: "40px Grill Sans",
      color: "White",
      text: "Daily Effort Distribution (Hours)"
    },
    dataSource:{
      data: dailyEffortDistributionData
    },
    legend:{
      position: "bottom"
    },
    series:[{
      field: "dev",
      name: "Dev"
    }, {
      field: "qa",
      name: "Qa"
    }, {
      field: "bug",
      name: "Bug"
    }, {
      type: "line",
      field: "req",
      name: "Closed Requirements"
    }],
    seriesDefaults:{
      stacked: true
    },
    categoryAxis:{
      field: "day",
      majorGridLines:{
        visible: false
      },
      labels:{
        font: "20px Grill Sans",
        color: "White"
      }
    },
    valueAxis:{
      majorGridLines:{
        visible: false
      },
      labels:{
        font: "15px Grill Sans",
        color: "White"
      }
    },
    tooltip:{
      visible: true,
      template: "${ category } - ${ value } Hours"
    }
  })
}

function createRequirementEffortChart(){
  $('#req-effort-chart').kendoChart({
    theme: "kendo",
    chartArea:{
      background: "transparent"
    },
    title:{
      font: "40px Grill Sans",
      color: "White",
      text: "Deliver Requirement Effort (Hours)"
    },
    legend:{
      visible: false
    },
    dataSource:{
      data: requirementEffort
    },
    series:[{
      type: "bar",
      field: "effort",
      name: "Effort"
    }],
    categoryAxis:{
      field: "source",
      majorGridLines:{
        visible: false
      },
      labels:{
        font: "20px Grill Sans",
        color: "White"
      }
    },
    valueAxis:{
      majorGridLines:{
        visible: false
      },
      labels:{
        font: "15px Grill Sans",
        color: "White"
      }
    },
    tooltip:{
      visible: true,
      template: "${ category } - ${ value } Hours"
    }
  })
}

function createRequirementDurationChart(){
  $('#req-duration-chart').kendoChart({
    theme: "kendo",
    chartArea:{
      background: "transparent"
    },
    title:{
      font: "40px Grill Sans",
      color: "White",
      text: "Deliver Requirement Duration (Days)"
    },
    legend:{
      visible: false
    },
    dataSource:{
      data: requirementDuration
    },
    series:[{
      field: "duration",
      name: "Duration"
    }],
    categoryAxis:{
      field: "source",
      majorGridLines:{
        visible: false
      },
      labels:{
        font: "20px Grill Sans",
        color: "White"
      }
    },
    valueAxis:{
      majorGridLines:{
        visible: false
      },
      labels:{
        font: "15px Grill Sans",
        color: "White"
      }
    },
    tooltip:{
      visible: true,
      template: "${ category } - ${ value } Days"
    }
  })
};

function createEffortDistributionChart(){
  $('#effort-distribution-chart').kendoChart({
    theme: "kendo",
    chartArea: {
      background: "transparent"
    },
    title: {
      font: "40px Grill Sans",
      color: "White",
      text: "Effort Distribution"
    },
    legend:{
      labels:{
        font: "16px Grill Sans",
        color: "White" 
      },
      position: 'bottom'
    },
    dataSource:{
      data: effortDistributionData
    },
    series:[{
      type: "pie",
      field: "percentage",
      categoryField: "source",
      startAngle: 160
    }],
    seriesDefaults:{
      labels:{
        font: "20px Gill Sans",
        color: "white",
        visible: true
      }
    },
    tooltip:{
      visible: true,
      template: "${ category } - ${ value }%"
    }
  });
};

function createActivityStream(){
  var paper = Raphael("activity-stream");

  var top = 230;
  var left = 150;
  var gap = 60;
  var radiusRate = 3.5;

  var titleAttr = {
    fill: "#FFF",
    font: "48px Grill Sans"
  };

  paper.text(600, 40, "Activity Stream").attr(titleAttr);

  var legendLabelAttrs = {
    fill: "#FFFFFF",
    font: "24px Grill Sans"
  };

  paper.path("M150 230H1050 230").attr({stroke: "#FFF"});
  paper.path("M150 380V400").attr({stroke: "#FFF"});
  paper.path("M150 400H250").attr({stroke: "#FFF"});
  paper.text(300, 400, "Week 1").attr(legendLabelAttrs);
  paper.path("M350 400H550").attr({stroke: "#FFF"});
  paper.path("M450 400V380").attr({stroke: "#FFF"});
  paper.text(600, 400, "Week 2").attr(legendLabelAttrs);
  paper.path("M650 400H850").attr({stroke: "#FFF"});
  paper.path("M750 400V380").attr({stroke: "#FFF"});
  paper.text(900, 400, "Week 3").attr(legendLabelAttrs);
  paper.path("M950 400H1050").attr({stroke: "#FFF"});
  paper.path("M1050 400V380").attr({stroke: "#FFF"});

  var datas1 = [14, 19, 0, 34, 16, 6, 7, 22, 4, 12, 6, 4, 1, 0, 1];
  var datas2 = [14, 4, 2, 8, 9, 10, 3, 0, 0, 0, 2, 2, 3, 32, 31];
  var datas3 = [0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0];

  for(var i = 0; i < 15; i++){
    var data1 = datas1[i];
    var data2 = datas2[i];
    var data3 = datas3[i];

    var circle1 = paper.circle(left + i*gap, top, data1*radiusRate).attr({fill: "#d8eb9f", opacity: .5, "stroke-width": 0});

    var circle2 = paper.circle(left + i*gap, top, data2*radiusRate).attr({fill: "#79cde7", opacity: .5, "stroke-width": 0})

    var circle3 = paper.circle(left + i*gap, top, data3*radiusRate).attr({fill: "#ff663a", opacity: .5, "stroke-width": 0})
  }

  var legendTextAttr = {
    fill: "#FFF",
    font: "24px Grill Sans"
  };

  paper.text(100, 450, "Size").attr(legendTextAttr);
  paper.path("m80 470H400").attr({stroke: '#FFF'});
  paper.text(100, 495, "Less").attr({fill: "#FFF", font: "16px Grill Sans"});
  paper.path("M105 510L180 580").attr({stroke: '#FFF'});

  var lessCircle = paper.circle(180, 580, 30);
  lessCircle.attr({fill: "#79cde7", opacity: .4, "stroke-width": 0});
  // lessCircle.mouseover(function(){
  //   this.stop().animate({transform: "s1.4 1.4 " + 180 + " " + 580}, 1000, "elastic");
  // }).mouseout(function(){
  //   this.stop().animate({transform: ""}, 1000, "elastic");
  // });
  
  paper.path("M260 580L360 670").attr({stroke: "#FFF"});
  paper.circle(260, 580, 70).attr({fill: "#79cde7", opacity: .4, "stroke-width": 0});
  paper.text(363, 685, "More").attr({fill: "#FFF", font: "16px Grill Sans"});

  paper.text(700, 450, "Categories").attr(legendTextAttr);
  paper.path("m650 470H1080").attr({stroke: '#FFF'});
  paper.circle(750, 580, 70).attr({fill: "#d8eb9f", opacity: .4, "stroke-width": 0});
  paper.text(745, 580, "Dev\nActivity").attr({fill: "#FFF", font: "22px Grill Sans"});
  paper.circle(870, 580, 70).attr({fill: "#79cde7", opacity: .4, "stroke-width": 0});
  paper.text(873, 580, "QA\nActivity").attr({fill: "#FFF", font: "22px Grill Sans"});
  paper.circle(990, 580, 70).attr({fill: "#ff663a", opacity: .4, "stroke-width": 0});
  paper.text(993, 580, "Bug\nActivity").attr({fill: "#FFF", font: "22px Grill Sans"});
}

Raphael.fn.pieChart = function (cx, cy, r, values, labels, stroke, title) {
    var paper = this,
        rad = Math.PI / 180,
        chart = this.set();
    function sector(cx, cy, r, startAngle, endAngle, params) {
        console.log(params.fill);
        var x1 = cx + r * Math.cos(-startAngle * rad),
            x2 = cx + r * Math.cos(-endAngle * rad),
            y1 = cy + r * Math.sin(-startAngle * rad),
            y2 = cy + r * Math.sin(-endAngle * rad);
        return paper.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"]).attr(params);
    }

  var titleAttr = {
    fill: "#FFF",
    font: "48px Grill Sans"
  };

  paper.text(600, 40, title).attr(titleAttr);

    
    var angle = 0,
        total = 0,
        start = 0,
        process = function (j) {
            var value = values[j],
                angleplus = 360 * value / total,
                popangle = angle + (angleplus / 2),
                color = Raphael.hsb(start, .75, 1),
                ms = 500,
                delta = 30,
                bcolor = Raphael.hsb(start, 1, 1),
                p = sector(cx, cy, r, angle, angle + angleplus, {fill: "90-" + bcolor + "-" + color, stroke: stroke, "stroke-width": 0}),
                txt = paper.text(cx + (r + delta + 55) * Math.cos(-popangle * rad), cy + (r + delta + 25) * Math.sin(-popangle * rad), labels[j]).attr({fill: bcolor, stroke: "none", opacity: 0, "font-size": 20});
            p.mouseover(function () {
                p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy}, ms, "elastic");
                txt.stop().animate({opacity: 1}, ms, "elastic");
            }).mouseout(function () {
                p.stop().animate({transform: ""}, ms, "elastic");
                txt.stop().animate({opacity: 0}, ms);
            });
            angle += angleplus;
            chart.push(p);
            chart.push(txt);
            start += .1;
        };
    for (var i = 0, ii = values.length; i < ii; i++) {
        total += values[i];
    }
    for (i = 0; i < ii; i++) {
        process(i);
    }
    return chart;
};

function createReqEffortDistributionPieChart(){
  var values = [],
      labels = [];
  $("#req-effort-distribution-table tr").each(function () {
      values.push(parseInt($("td", this).text(), 10));
      labels.push($("th", this).text());
  });
  $("#req-effort-distribution-table").hide();
  Raphael("req-effort-distribution-pie-chart", 900, 600).pieChart(550, 300, 200, values, labels, "#fff", "Requirement Effort Pie Chart");
};

var attentionCollection = new Array();

Raphael.fn.createTextWidget = function(attention, desc){
  var paper = this;
  var attentionAttr = {
    fill: "#FFF",
    font: "68px Grill Sans"
  };
  var descAttr = {
    fill: "#FFF",
    font: "28px Grill Sans"
  };
  var backgroundRectAttr = {
    fill: "#c63cea",
    "stroke-width": 0
  };

  paper.rect(19, 30, 300, 100, 15).attr(backgroundRectAttr);
  var attention = paper.text(80, 35, attention).attr(attentionAttr).transform("s0.4 0.4");
  attentionCollection.push(attention);
  paper.text(180, 85, desc).attr(descAttr);
}

function createReqDoneWidget(){
  var paper = Raphael("req-done");
  paper.createTextWidget('20', "Requirements\nhave been Done");
  Raphael("deliver-rate").createTextWidget('50%', 'Deliver Rate');
}

function animateNumbers(){
  for(var i = 0; i < attentionCollection.length; ++i){
    attentionCollection[i].animate({transform: ""}, 1000, 'elastic');
  }
}

$(document).ready(function(){
  createReqDoneWidget();
  createEffortDistributionChart();
  createRequirementDurationChart();
  createRequirementEffortChart();
  createDailyEffortDistributionChart();
  createActivityStream();
  createReqEffortDistributionPieChart();

  setTimeout("animateNumbers()", 1000);
});