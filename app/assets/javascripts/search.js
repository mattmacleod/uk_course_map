ukcoursemap.search = {

	setup: function(){
		$("#search_button").click(function(){
			$.ajax({
				url: "/filter_results.json",
				type: "GET",
				data: $("#search_form").serialize(),
				success: function(data){

				}
			});
			return false;
		});

	}

};