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
  font: "28px Bell MT",
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

function makeUpTitle(){
  Raphael('title-text').textWithAttr(titleAttr, 280, 50, config.title);

  var width = $('#title-color-label-left').width();
  var height = $('#title-color-label-left').height() - 40;
  Raphael('title-color-label-left').rectWithAttr(colorLabelAttr, 0, 20, width, height);
  Raphael('title-color-label-right').rectWithAttr(colorLabelAttr, 0, 20, width, height);
}

function createSubTitle(id, subTitle){
  paper = Raphael(id);
  var element = paper.textWithAttr(subTitleAttr, 0, 50, subTitle);
  var start = element.node.clientWidth + 5;
  var width = element.node.parentNode.clientWidth;
  paper.path("M" + (start) + " 50H" + width).attr({stroke: "#000000"});
}

function createTotalEffortDistributionChart(){
  paper = Raphael('total-effort-distribution-chart');

  devEffort = config.requirement.effortDistribution.dev;
  qaEffort = config.requirement.effortDistribution.qa;

  qaDevRatio = (qaEffort / devEffort) * 1.0;

  qaTransFactor = (105/qaEffort)*1.0;
  console.log(qaTransFactor);
  devTransFactor = (105/devEffort)*1.0;
  console.log(devTransFactor);

  standardRadius = 90 / Math.max.apply(Math, [devTransFactor, qaTransFactor]);

  devX = 90;
  devY = 90;
  qaX = 245;
  qaY = 90;
  bottom = 200;

  circleAttr.fill = devColor;
  requirementHours.push(paper.circle(devX, devY, standardRadius * qaTransFactor)
                             .attr(circleAttr)
                             .transform("s0.0 0.0"));

  paper.path("m" + devX + " " + (devY + standardRadius * qaTransFactor) + " V" + bottom).attr({stroke: devColor});
  paper.textWithAttr({font: "16px Bell MT", "font-weight" : "bold", fill: devColor}, devX, bottom + 10, 'Dev Effort');
  paper.textWithAttr({font: "30px Bell MT", fill: "#fff"}, devX, devY, devEffort + ' hr');

  circleAttr.fill = qaColor;
  requirementHours.push(paper.circle(qaX, qaY, standardRadius * devTransFactor)
                             .attr(circleAttr)
                             .transform("s0.0 0.0"));

  paper.path("m" + qaX + " " + (qaY + standardRadius * devTransFactor) + " V" + bottom).attr({stroke: qaColor});
  paper.textWithAttr({font: "16px Bell MT", "font-weight" : "bold",fill: qaColor}, qaX, bottom + 10, 'QA Effort');
  paper.textWithAttr({font: "30px Bell MT", fill: "#fff"}, qaX, qaY, qaEffort + ' hr');

  start = devX - 50;
  dev = 3;
  for(var i = 0; i < dev; i++){
    paper.rect(start + i * 15, bottom + 50, 10, 40).attr({fill: devColor, "stroke-width": 0, opacity: .7});
  }

  start = start + dev*15
  qa = 5;
  for(var i = 0; i < qa; i++){
    paper.rect(start + i * 15, bottom + 50, 10, 40).attr({fill: qaColor, "stroke-width": 0, opacity: .7});
  }

  start = start + qa*15 + 30;
  paper.text(start, bottom + 70, config.requirement.done).attr({font: "54px Gill Sans", "font-weight": "bold"});
  paper.text(start + 100, bottom + 60, "requirements").attr({font: "22px Bell MT"});
  paper.text(start + 107, bottom + 83, "have been done").attr({font: "22px Bell MT"});
}

function createRequirementCharts(){
  createSubTitle('req-done-title', config.requirement.subTitleDone);
  createSubTitle('req-duration-title', config.requirement.subTitleDuration);
  createTotalEffortDistributionChart();
}

function createRequirementDurationChart(){
  $('#req-duration-chart').kendoChart({
    theme: 'kendo',
    title: {
      visible: false
    },
    seriesDefaults: {
      type: "bar",
      stack: true,
      gap: 0,
      spacing: 0
    },
    chartArea:{
      margin: 0
    },
    dataSource:{
      data: requirementData
    },
    legend:{
      position: "bottom"
    },
    plotArea:{
      margin: 0
    },
    series:[{
      field: "design",
      name: "Design",
      gap: 0,
      color: "#3b6e54",
    },{
      field: "coding",
      name: "Coding",
      gap: 0,
      color: devColor,
      opacity: .7
    },{
      field: "testing",
      name: "Testing",
      gap: 0,
      color: qaColor,
      opacity: .7
    }],
    categoryAxis:{
      field: "key",
      majorGridLines:{
        visible: false
      },
      labels:{
        font: "16px Bell MT",
        color: "#000"
      }
    },
    valueAxis:{
      majorGridLines:{
        visible: false
      }
    },
  });
  paper = Raphael('req-duration-desc');
  gap = 3;
  paper.rect(0, 0, 50, 53).attr({fill: "#FFF", 'stroke-width': 3, stroke: 'grey'});
  paper.rect(5, 5, 100, 5).attr({fill: devColor, 'stroke-width': 0});
  paper.rect(5, gap + 5*2, 40, 5).attr({fill: devColor, 'stroke-width': 0});
  paper.rect(5, gap*2 + 5*3, 36, 5).attr({fill: devColor, 'stroke-width': 0});
  paper.rect(5, gap*3 + 5*4, 30, 5).attr({fill: devColor, 'stroke-width': 0});
  paper.rect(5, gap*4 + 5*5, 10, 5).attr({fill: devColor, 'stroke-width': 0});
  paper.rect(5, gap*5 + 5*6, 5, 5).attr({fill: devColor, 'stroke-width': 0});

  paper.text(80, 33, '13').attr({font: "54px Gill Sans", 'font-weight': 'bold', color: "#000"});
  paper.text(180, 23, 'days average').attr({font: "20px Grill Sans"});
  paper.text(177, 42, 'deliver time').attr({font: "20px Grill Sans"});

  paper.text(300, 33, '14').attr({font: "54px Gill Sans", 'font-weight': 'bold', color: "#000"});
  paper.text(400, 23, 'days longest').attr({font: "20px Grill Sans"});
  paper.text(397, 42, 'deliver time').attr({font: "20px Grill Sans"});
}

activities = [];
var currentActivityIndex = 0;
var displayDevActivities = true;
var displayQaActivities = true;
var displayBugActivities = true;

function createActivityStream(){
  createSubTitle('activity-stream-title', 'Activity Stream');
  var paper = Raphael("activity-stream");

  var top = 130;
  var left = 90;
  var gap = 50;
  var radiusRate = 1.5;

  var titleAttr = {
    fill: "#FFF",
    font: "48px Grill Sans"
  };

  var legendLabelAttrs = {
    fill: "#3c3d3b",
    font: "20px Grill Sans",
  };

  paper.path("M90 130H790");

  paper.path("M90 280V300");
  paper.path("M90 300H160");
  paper.text(210, 300, "Week 1").attr(legendLabelAttrs);
  paper.path("M255 300H325");
  paper.path("M325 300V280");
  paper.path("M325 300H410");
  paper.text(460, 300, "Week 2").attr(legendLabelAttrs);
  paper.path("M500 300H560");
  paper.path("M560 300V280");
  paper.path("M560 300H620");
  paper.text(670, 300, "Week 3").attr(legendLabelAttrs);
  paper.path("M720 300H790");
  paper.path("M790 300V280");

  var datas1 = config.devActivities;
  var datas2 = config.qaActivities;
  var datas3 = config.bugActivities;

  for(var i = 0; i < 15; i++){
    var data1 = datas1[i];
    var data2 = datas2[i];
    var data3 = datas3[i];

    var circle1 = paper.circle(left + i*gap, top, data1*radiusRate)
                       .attr({fill: devColor, opacity: .6, "stroke-width": 0})
                       .transform("s0.0 0.0");
    if(data1 > 0)
      activities.push({type: 'dev', graph: circle1});

    var circle2 = paper.circle(left + i*gap, top, data2*radiusRate)
                       .attr({fill: qaColor, opacity: .6, "stroke-width": 0})
                       .transform("s0.0 0.0");
    if(data2 > 0)
      activities.push({type: 'qa', graph: circle2});

    var circle3 = paper.circle(left + i*gap, top, data3*radiusRate)
                       .attr({fill: "#ff663a", opacity: .6, "stroke-width": 0})
                       .transform("s0.0 0.0");
    if(data3 > 0)
      activities.push({type: 'bug', graph: circle3});
  }

  var legendTextAttr = {
    fill: "#3c3d3b",
    font: "24px Grill Sans"
  };

  // paper.text(100, 390, "Size").attr(legendTextAttr);
  // paper.path("m80 405H400").attr({stroke: '#000'});
  paper.text(131, 400, "Less").attr({fill: "#000", font: "16px Grill Sans"});

  var lessCircle = paper.circle(131, 400, 30);
  lessCircle.attr({fill: "#79cde7", opacity: .6, "stroke-width": 0});
  
  paper.text(200, 440, "More").attr({fill: "#000", font: "16px Grill Sans"});
  paper.circle(200, 440, 50).attr({fill: "#79cde7", opacity: .6, "stroke-width": 0});
  

  // paper.text(400, 450, "Categories").attr(legendTextAttr);
  // paper.path("m450 470H1080").attr({stroke: '#000'});
  paper.text(450, 440, "Dev\nActivity").attr({fill: "#000", font: "22px Grill Sans"});
  paper.circle(450, 440, 50).attr({fill: devColor, opacity: .6, "stroke-width": 0});
  
  paper.text(570, 440, "QA\nActivity").attr({fill: "#000", font: "22px Grill Sans"});
  paper.circle(570, 440, 50).attr({fill: qaColor, opacity: .6, "stroke-width": 0});
  
  paper.text(690, 440, "Bug\nActivity").attr({fill: "#000", font: "22px Grill Sans"});
  paper.circle(690, 440, 50).attr({fill: "#ff663a", opacity: .6, "stroke-width": 0});
  
}

function createQualityBadge(id, number, text1, text2, color){
  paper = Raphael(id);
  // paper.rect(0, 0, 30, 50).attr({fill: color, 'stroke-width': 0, opacity: .7});
  // paper.rect(350, 0, 30, 50).attr({fill: color, 'stroke-width': 0, opacity: .7});
  paper.text(33, 53, number).attr({font: "54px Gill Sans", "font-weight": "bold"})
                            .mouseover(function(){
                               this.toFront().animate({transform: "s1.8 1.8t20 0"}, 200, 'linear');
                             }).mouseout(function(){
                               this.animate({transform: ""}, 300, 'elastic');
                             });

  paper.image('/assets/bug.png', 80, 30, 48, 48);
  
  if (text1.length > 0)
    paper.text( 235, 54, text1).attr({font: "28px Grill Sans", 'font-weight': 'bold'});
  
  if (text2.length > 0)
    paper.text( 225, 45, text2).attr({font: "24px Grill Sans", 'font-weight': 'bold', fill: color, opacity: .7}).transform("r-35");  
  
  paper.rect(0, 100, 350, 5).attr({fill: color, 'stroke-width': 0, opacity: .7});
}


function createQualitySummary(){
  createSubTitle('quality-summary-title', 'Bug Summary');
  createReqBugDistributionPieChart();
  createQualityBadge('bugs-in-total', 90, 'in Total', "", "#e0d00e");
  createQualityBadge('most-buggy', mostBuggyRequirement.bug_count, 'FNDCAMP-8088', "Most Buggy", qaColor);
  createQualityBadge('best-quality', 4, 'FNDCAMP-8087', "Best Quality", "#b80649");
  createReqBugBarChart();
}

function createReqBugBarChart(){
  var paper = Raphael("req-bug-priority-chart", 500, 445);
  fin = function(){
    this.flag = paper.popup(this.bar.x, this.bar.y, this.bar.value || "0").insertBefore(this);
  };
  fout = function(){
    this.flag.animate({opacity: 0}, 300, function(){this.remove();});
  };

  hbarchart = paper.hbarchart(100, 20, 350, 220, bug_priority_distribution, {type: 'soft'}).hover(fin, fout);

  paper.text(80, 45, 'P0').attr({font: "24px Grill Sans"});
  paper.text(80, 90, 'P1').attr({font: "24px Grill Sans"});
  paper.text(80, 130, 'P2').attr({font: "24px Grill Sans"});
  paper.text(80, 175, 'P3').attr({font: "24px Grill Sans"});
  paper.text(80, 215, 'P4').attr({font: "24px Grill Sans"});

  paper.text(280, 250, "Bug Distribution by Count").attr({ font: "20px 'Grill Sans'" });
}

function createReqBugDistributionPieChart(){
  var paper = Raphael("req-bug-distribution-chart", 700, 445),

  pie = paper.piechart(350, 200, 140, bug_distribution_values, { legend: bug_distribution_labels, legendpos: "west", href: bug_distribution_links});

  paper.text(340, 400, "Bug Distribution by Count").attr({ font: "20px 'Grill Sans'" });
  pie.hover(function () {
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
}

var activitiesToAnimate = [];
function animateActivities(){
  var activity = activitiesToAnimate[currentActivityIndex++];
  activity.animate({transform: ""}, 600, 'elastic');
  
  if(currentActivityIndex < activitiesToAnimate.length) {
    setTimeout("animateActivities()", 350);
  } else {
    $('#activity-stream-replay-btn').removeAttr('disabled');
  }
}

function animateRequirementHour(){
  requirementHours[0].animate({transform: ""}, 500, 'elastic', function(){
    requirementHours[1].animate({transform: ""}, 500, 'elastic');
  });
  setTimeout("activityStreamReplay()", 1000);
}

function startAnimation() {
  setTimeout("animateRequirementHour()", 500);
}

function activityStreamReplay(){
  for(var i = 0; i < activities.length; ++i){
    activities[i].graph.transform("s0.0 0.0");
  }
  activitiesToAnimate = []
  for(var i = 0; i < activities.length; ++i){
    if(displayDevActivities && activities[i].type == 'dev'){
      activitiesToAnimate.push(activities[i].graph);
    }
    else if(displayQaActivities && activities[i].type == 'qa'){
      activitiesToAnimate.push(activities[i].graph);
    }
    else if(displayBugActivities && activities[i].type == 'bug'){
      activitiesToAnimate.push(activities[i].graph);
    }
  }
  currentActivityIndex = 0;
  animateActivities();
}

$(document).ready(function(){
  makeUpTitle();
  createRequirementCharts();
  createRequirementDurationChart();
  createActivityStream();
  createQualitySummary();

  $('#activity-stream-replay-btn').attr('disabled', 'true');

  startAnimation();

  $('#activity-stream-replay-btn').click(function(){
    $(this).attr('disabled', 'disabled');
    activityStreamReplay();
  });

  $('#dev').attr('checked', 'checked');
  $('#qa').attr('checked', 'checked');
  $('#bug').attr('checked', 'checked');

  $('#dev').click(function(){
    displayDevActivities = false;
    if ($('#dev').is(':checked')) {
      displayDevActivities = true;
    }
  });

  $('#qa').click(function(){
    displayQaActivities = false;
    if ($('#qa').is(':checked')) {
      displayQaActivities = true;
    }
  });

  $('#bug').click(function(){
    displayBugActivities = false;
    if ($('#bug').is(':checked')) {
      displayBugActivities = true;
    }
  });
})