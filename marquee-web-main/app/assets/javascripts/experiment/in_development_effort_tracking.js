Raphael.fn.textWithAttr = function(textAttr, x, y, width, height){
  return this.text(x, y, width, height).attr(textAttr);
};

Raphael.fn.rectWithAttr = function(rectAttr, x, y, width, height, radius){
  return this.rect(x, y, width, height, radius).attr(rectAttr);
};

var titleAttr = {
  font: "38px Gill Sans",
  fill: "#7a8080",
  "font-weight": "bold",
  "text-anchor": "middle",
};

var subTitleAttr = {
  font: "18px Bell MT",
  color: "#000000",
  "text-anchor": "start"
};

var colorLabelAttr = {
  "stroke-width": 0,
  fill: '#7a8080'
};

var circleAttr = {
  fill: '#00b0f9',
  "stroke-width": 0,
  opacity: .7,
}

var devColor = "#ff0075";
var qaColor = "#00b0f9";
var requirementHours = [];
var detailPieChart;

function makeUpTitle(){
  Raphael('title-text').textWithAttr(titleAttr, 340, 50, config.title);

  var width = $('#title-color-label-left').width();
  var height = $('#title-color-label-left').height() - 40;
  Raphael('title-color-label-left').rectWithAttr(colorLabelAttr, 0, 20, width, height);
  Raphael('title-color-label-right').rectWithAttr(colorLabelAttr, 0, 20, width, height);
  Raphael('sub-title').text(835, 8, subTitle).attr({font: '18px Grill Sans'});
}

function createSubTitle(id, subTitle){
  paper = Raphael(id);
  var element = paper.textWithAttr(subTitleAttr, 0, 50, subTitle);
  var start = element.node.clientWidth + 5;
  var width = element.node.parentNode.clientWidth;
  paper.path("M" + (start) + " 50H" + width).attr({stroke: "#000000"});
}

function fin(){
  this.stop().animate({transform: 's1.5 1.5'}, 500, 'elastic');
}

function fout(){
  this.stop().animate({transform: ''}, 500, 'elastic');
}

function createTotalEffortDistributionChart(){
  paper = Raphael('effort-distribution-chart');

  color1 = "#ff0075";
  color2 = "#00b0f9";
  color3 = "#8209a5";

  data1 = config.inReleaseEffort;
  data2 = config.outReleaseEffort;
  data3 = config.otherProjEffort;

  factor1 = (data1/105)*1.0;
  factor2 = (data2/105)*1.0;
  factor3 = (data3/105)*1.0;

  console.log(factor1 + " " + factor2 + " " + factor3);

  standardRadius = 60 / Math.max.apply(Math, [factor1, factor2, factor3 ]);

  x1 = 90;
  y1 = 90;
  x2 = 215;
  y2 = 90;
  x3 = 340;
  y3 = 90;

  rad1 = standardRadius * factor1
  rad2 = standardRadius * factor2
  rad3 = standardRadius * factor3

  if(rad1 < 50) rad1 = 50
  if(rad2 < 50) rad2 = 50
  if(rad3 < 50) rad3 = 50

  bottom = 200;

  circleAttr.fill = color1;
  requirementHours.push(paper.circle(x1, y1, rad1)
                             .attr(circleAttr)
                             .transform("s0.0 0.0"));

  paper.path("m" + x1 + " " + (y1 + rad1) + " V" + bottom).attr({stroke: color1});
  paper.textWithAttr({font: "16px Bell MT", "font-weight" : "bold", fill: color1}, x1, bottom + 20, 'In Release\nEffort');
  paper.textWithAttr({font: "30px Bell MT", fill: "#FFF"}, x1, y1, data1 + ' hr');

  circleAttr.fill = color2;
  requirementHours.push(paper.circle(x2, y2, rad2)
                             .attr(circleAttr)
                             .transform("s0.0 0.0"));

  paper.path("m" + x2 + " " + (y2 + rad2) + " V" + bottom).attr({stroke: color2});
  paper.textWithAttr({font: "16px Bell MT", "font-weight" : "bold",fill: color2}, x2, bottom + 20, 'Other Release\nEffort');
  paper.textWithAttr({font: "30px Bell MT", fill: "#FFF"}, x2, y2, data2 + ' hr');

  circleAttr.fill = color3;
  requirementHours.push(paper.circle(x3, y3, rad3)
                             .attr(circleAttr)
                             .transform("s0.0 0.0"));
  paper.path("m" + x3 + " " + (y3 + rad3) + " V" + bottom).attr({stroke: color3});
  paper.textWithAttr({font: "16px Bell MT", "font-weight" : "bold",fill: color3}, x3, bottom + 20, 'Other Project\nEffort');
  paper.textWithAttr({font: "30px Bell MT", fill: "#FFF"}, x3, y3, data3 + ' hr');

  start = x1 - 50;
  count1 = 8;
  for(var i = 0; i < count1; i++){
    paper.rect(start + i * 15, bottom + 90, 10, 40).attr({fill: color1, "stroke-width": 0, opacity: .7});
  }

  start = start + count1*15
  count2 = 1;
  for(var i = 0; i < count2; i++){
    paper.rect(start + i * 15, bottom + 90, 10, 40).attr({fill: color2, "stroke-width": 0, opacity: .7});
  }

  start = start + count2*15
  count3 = 1;
  for(var i = 0; i < count3; i++){
    paper.rect(start + i * 15, bottom + 90, 10, 40).attr({fill: color3, "stroke-width": 0, opacity: .7});
  }

  start = start + count3*15 + 20;
  paper.text(start + 40, bottom + 110, config.totalEffort).attr({font: "54px Gill Sans", "font-weight": "bold"});
  paper.text(start + 151, bottom + 100, "hours have").attr({font: "22px Bell MT"});
  paper.text(start + 157, bottom + 123, "been logged").attr({font: "22px Bell MT"});
}

function createRequirementCharts(){
  createSubTitle('req-done-title', config.requirement.subTitleDone);
  createSubTitle('req-duration-title', config.requirement.subTitleDuration);
  createTotalEffortDistributionChart();
}

function animateRequirementHour(){
  requirementHours[0].animate({transform: ""}, 500, 'elastic', function(){
    requirementHours[1].animate({transform: ""}, 500, 'elastic', function(){
      requirementHours[2].animate({transform: ""}, 500, 'elastic', function(){
        detailPieChart.animate({opacity: 1}, 1000, 'elastic');
      });
    });
  });
  // setTimeout("animateActivities()", 1500);
}

function startAnimation() {
  setTimeout("animateRequirementHour()", 500);
}

function activityStreamReplay(){
  for(var i = 0; i < activities.length; ++i){
    activities[i].transform("s0.0 0.0");
  }
  currentActivityIndex = 0;
  animateActivities();
}

function createEffortDistributionPieChart(){
  createSubTitle('effort-distribution-chart-title', "Effort Distribution Overview");

  createTotalEffortDistributionChart();

  createSubTitle('detail-effort-distribution-chart-title', "Effort Distribution in Detail");
  var paper2 = Raphael("detail-effort-distribution-chart", 960, 340);
  paper2.text(150, 320, 'Unit: Hour').attr({font: "22px Grill Sans"});

  var pie2 = paper2.piechart(150, 160, 130, 
    detailEffortDistributionData, 
    {legend: detailEffortDistributionLabels, lengendpos: 'east', legendmargin: 5}
  ).attr({opacity: 0});

  pie2.hover(function () {
    this.sector.stop();
    this.sector.scale(1.1, 1.1, this.cx, this.cy);

    if (this.label) {
        this.label[0].stop();
        this.label[0].attr({ r: 7.5 });
        this.label[1].attr({ "font-weight": 800 });
    }
  }, function () {
    this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");

    if (this.label) {
        this.label[0].animate({ r: 5 }, 500, "bounce");
        this.label[1].attr({ "font-weight": 400 });
    }
  });

  detailPieChart = pie2;
}

function createQualityMetrics(){
  createSubTitle('bug-metrics-title', "Bug Metrics");
  createSubTitle('bug-data-title', 'Bug Data');
  createSubTitle('bug-trend-title', "Daily New Bug Heat Chart");

  var paper = Raphael("bug-metrics-chart", 480, 350);
  fin = function(){
    this.flag = paper.popup(this.bar.x, this.bar.y, this.bar.value || "0").insertBefore(this);
  };
  fout = function(){
    this.flag.animate({opacity: 0}, 300, function(){this.remove();});
  };

  hbarchart = paper.hbarchart(120, 20, 280, 220, openBugsCountByPriority, {type: 'soft'}).hover(fin, fout);

  paper.text(80, 40, 'P0').attr({font: "24px Grill Sans"});
  paper.text(80, 85, 'P1').attr({font: "24px Grill Sans"});
  paper.text(80, 130, 'P2').attr({font: "24px Grill Sans"});
  paper.text(80, 170, 'P3').attr({font: "24px Grill Sans"});
  paper.text(80, 215, 'P4').attr({font: "24px Grill Sans"});

  paper.text(240, 260, "Bug Distribution by Priority").attr({ font: "20px 'Grill Sans'" });

  var r = Raphael('bug-trend-chart', 1000, 200);
  var xs = new Array();
  for(var i = 0; i < openBugsCountByDay.length; ++i){
    xs.push(i+i*2);
  }

  var ys = new Array();
  for(var i = 0; i < openBugsCountByDay.length; ++i){
    ys.push(10);
  }

  data = openBugsCountByDay;
  axisx = openBugsCountByDayLabels;
  axisy = ['Bugs'];

  r.text(15, 90, 'Bug Count').rotate(270).attr({font: '14px Grill Sans'});

  r.dotchart(10, 0, 960, 150, xs, ys, data, 
    {symbol: 'o', max: 50, heat: true, opacity: .8,
      axisxlabels: axisx, axis: "0 0 1 1",
      axisxtype: " ", axisytype: " ", axisylabels: axisy}).hover(function(){
    this.marker = this.marker || r.tag(this.x, this.y, this.value, 0, this.r + 2).insertBefore(this);
    this.marker.show();
  }, function(){
      this.marker && this.marker.hide();
  });
}

$(document).ready(function(){
  
  makeUpTitle();

  createEffortDistributionPieChart();

  createQualityMetrics();

  startAnimation();
})