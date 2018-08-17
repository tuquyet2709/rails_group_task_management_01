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
  var url = 'http://gtm2018.herokuapp.com/en/add_user_subtask?subtask[id]='+t+'&subtask[user_id]='+id;
  xhttp.open('GET', url, true);
  xhttp.send();
  var x = document.getElementById('user-div');
  x.style.display = 'none';
  var button = document.getElementById('button'+t);
  button.value = name;
}
