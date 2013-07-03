// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function getTasks(contest_id)
{
    $.ajax({
        type: "GET", 
        url: "/contest_tasks.json",
        data: {'contest_id':contest_id},
        async: false,
        success: function(data){
            ret = data;
        }
    });
    return ret;
}

function getTask(contest_id,serial)
{
	$.ajax({
		type: "GET",
		url: "/contest_tasks/"+contest_id+"/"+serial,
		async: false,
		success: function(data) {
			ret = data;
		}
	});
	return ret;
}

function appendTask(contest_id,task_id,serial)
{
	  $.ajax({
		    type: "POST",
		    url: "/contest_tasks.json",
        data:{'contest_task[contest_id]':contest_id,'contest_task[task_id]':task_id,'contest_task[serial]':serial,_method:'POST'},
		    async: false,
		    success: function(data) {
            ret = data;
		    }
	  });
	  return ret;
}

function removeTask(id)
{
	  $.ajax({
		    type: "POST",
		    url: "/contest_tasks/"+id+".json",
        data: {_method:'DELETE'},
		    async: false,
		    success: function(data) {
			      ret = data;
		    }
	  });
	  return ret;
}
