var ping = null;

$(function(){
	ping = function(){
		var ping_status;
		$.ajax({
			type: "GET",
			async: false,
			url: "/",
			success: function(){
				ping_status = true;
			},
			error: function(){
				ping_status = false;
			}
		});
		return ping_status;
	}
});