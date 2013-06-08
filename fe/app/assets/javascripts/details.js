// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function getDetails(result_id)
{
    $.ajax({
        type: "GET",
        url: "/details/"+result_id+".json",
        async: false,
        success: function(data){
            ret = data;
        }
    });
    return ret;
}
