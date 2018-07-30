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
