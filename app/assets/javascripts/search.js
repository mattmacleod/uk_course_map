ukcoursemap.search = {

	setup: function(){
		$("#search_button").click(function(){

			$("#search_button").after("<div id='search_spinner'/>").fadeIn();

			$("#search_spinner").fadeIn();
			
			$.ajax({
				url: "/filter_results.json",
				type: "GET",
				data: $("#search_form").serialize(),
				success: function(data){
					$("#search_spinner").fadeOut(function(){ $(this).remove(); });
				}
			});
			return false;
		});

	}

};