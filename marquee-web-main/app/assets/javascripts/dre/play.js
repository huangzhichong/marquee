//specify the container id for the slide content in the source page.
;;;var slide_content_selector = '#inner-content';

var slide_player;

$(function() {
    //get source page url list
    var slide_url_list = function() {
        $.ajaxSetup({async:false});
        $('#next_slide').load('/dre/overall');
        var url_list = [];
        $('.sidebar ul.play-menu a').each(function(index,elem) {
            url_list.push($(elem).attr('href')+'?slide=true');
        });
        return  url_list;
    }();
    //display first slide for 30s.
    time_line = {1:30000};
    slide_player = init_player(slide_url_list, time_line);
    //default slide display duration is 15s.
    slide_player.start_play(15000);
})


//@param url_list
//@param time_line specify the duration of displaying a particular slide. (key-value like {index:duration(ms)}, index starts from 1)

/*function() {
    $('#next_slide').empty();
}*/

var init_player = function(url_list, time_line) {
    var _current_slide_index = 0;
    var _slide_url_list = url_list;
    var _slide_count = url_list.length;
    var _time_line = time_line;
    var _job_id;

    var _show_next_slide = function() {

        var show = 'fadeIn';
        var hide = 'fadeOut';

        if ($('#next_slide ' + slide_content_selector)) {

            $('#slide')[hide]("normal",function(){
                $('#slide').empty();
                $('#slide').append($('#next_slide ' + slide_content_selector))});

            $('#slide')[show]("normal", function() {
           });}
    }

    var _show_slide = function(index) {

        if (index >= _slide_count) {
            alert("error");
            return;
        }

        $('#next_slide').empty();
        $.ajaxSetup({async:false});
        $('#next_slide').load(_slide_url_list[index]);
        setTimeout(_show_next_slide, 1000);
        _current_slide_index = index;
    }

    var _next_slide = function() {
        _show_slide((++_current_slide_index)%_slide_count);
    }

    var _prev_slide = function() {
        _show_slide((--_current_slide_index)%_slide_count);
    }

    var _play = function(interval) {
        clearTimeout(_job_id);

        _next_slide();
        var _interval = _time_line[_current_slide_index+1] || interval || 15000;
        _job_id = setTimeout(function() {_play(interval)}, _interval);
    }

    var _resize_slide = function() {
        $('#slide').css({width:$("body").width(),
                        height:($("body").height() - $('#slide').css('padding-top').substring(0, 2))});
    }

    //resize the slide to fit the window every 3 seconds.
    setInterval(_resize_slide, 3000);

    return {
        next_slide:_next_slide,
        prev_slide:_prev_slide,
        show_slide:_show_slide,
        pause: function() {clearTimeout(_job_id);_job_id=0;},
        continue_play:_play,
        //@param default slide display duration
        start_play:function(interval){_current_slide_index=-1;_play(interval)}
    }
}
