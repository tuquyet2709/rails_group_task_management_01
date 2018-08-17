//= require jquery.searchable.min
const COMPLETED = 3;
const WEB_PATH = "http://gtm2018.herokuapp.com";
const LOCAL_PATH = "http://0.0.0.0:3000";
const URL_TEST = WEB_PATH;

$(document).ready(function(){
  $("a#addbut").click(function(){
    var next_value = $("#child_fields li").length - 1;
    $('li#add-date')
      .append(
        '<li><label for="task_subtasks_attributes_' +
          next_value + '_content">Content </label><input name="task[subtasks_attributes][' +
          next_value + '][content]" ' + 'id="task_subtasks_attributes_' +
          next_value + '_content" type="text"></li>'
      );
  });
});

$(function () {
    $('#contact-list').searchable({
      searchField: '#contact-list-search',
      selector: 'li',
      childSelector: '.name',
      show: function( elem ) {
        elem.slideDown(100);
      },
      hide: function( elem ) {
        elem.slideUp( 100 );
      }
    })
});

var t = 0;

function myFunction(id) {
  t = id;
  var x = document.getElementById('user-div');
    if (x.style.display === 'inline') {
        x.style.display = 'none';
    } else {
        x.style.display = 'inline';
    }
}

function alert_link(id,name) {
  var xhttp = new XMLHttpRequest();
  var url = URL_TEST+'/en/add_user_subtask?subtask[id]='+t+'&subtask[user_id]='+id;
  xhttp.open('GET', url, true);
  xhttp.send();
  var x = document.getElementById('user-div');
  x.style.display = 'none';
  var button = document.getElementById('button'+t);
  button.value = name;
}

var previous_value = 0;

function get_value(subtask_id){
  var e = document.getElementById(subtask_id);
  previous_value = e.options[e.selectedIndex].value;
}

function change_status(subtask_id,task_id){
  var e = document.getElementById(subtask_id);
  var selected_value = e.options[e.selectedIndex].value;
  var now_value = $("#dynamic"+task_id).attr("aria-valuenow");
  var max_value = $("#dynamic"+task_id).attr("aria-valuemax");
  if(selected_value == COMPLETED ){
    current_progress = ((++now_value) *100)/max_value;
    $("#dynamic"+task_id).css("width", current_progress+ "%")
      .attr("aria-valuenow", now_value)
      .text(Math.floor(current_progress)+"%");
  }
  else{
    if (previous_value == COMPLETED) {
      current_progress = ((--now_value) *100)/max_value;
      $("#dynamic"+task_id).css("width", current_progress+ "%")
        .attr("aria-valuenow", now_value)
        .text(Math.round(current_progress)+"%");
    }
  }
  var xhttp = new XMLHttpRequest();
  var url = URL_TEST+'/en/change_subtask?subtask[id]='+subtask_id+'&subtask[status]='+selected_value;
  xhttp.open('GET', url, true);
  xhttp.send();
}

function estimate(ele){
  if(event.key === 'Enter') {
      var xhttp = new XMLHttpRequest();
      var url = URL_TEST+'/en/estimate?subtask[id]='+ele.name+'&subtask[estimate]='+ele.value;
      xhttp.open('GET', url, true);
      xhttp.send();
      alert("updated estimate time: "+ele.value);
    }
}
