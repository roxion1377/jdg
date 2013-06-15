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

function  getContests()
{
	$.ajax({
		type:"GET",
		url:"/contests.json",
		async:false,
		success: function(data) {
			ret = data;
		}
	});
	return ret;
}

function getSubmittion(id,offset)
{
	  $.ajax({
		    type:"GET",
		    url:"/results/"+id+".json",
		    async:false,
        data:{'offset':offset},
		    success: function(data) {
			      ret = data;
		    }
	  });
    return ret;
}

function getMySubmittion(id,offset)
{
          $.ajax({
                    type:"GET",
                    url:"/results/"+id+"/my.json",
                    async:false,
        data:{'offset':offset},
                    success: function(data) {
                              ret = data;
                    }
          });
    return ret;
}


function getRanking(id)
{
	$.ajax({
		type:"GET",
		url:"/contests/"+id+"/ranking.json",
		async:false,
		success: function(data) {
			ret = data;
		}
	});
	return ret;
}
