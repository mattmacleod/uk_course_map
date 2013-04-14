ukcoursemap.search = {

	setup: function(){

		$("#search_form").submit(function(){return false;});
		$("#search_button").click(function(){

			$("#search_button").after("<div id='search_spinner'/>").fadeIn();

			$("#search_spinner").fadeIn();

			$.ajax({
				url: "/filter_results.json",
				type: "GET",
				data: $("#search_form").serialize(),
				success: function(data){
					console.log(data);
					$("#search_spinner").fadeOut(function(){ $(this).remove(); });
					var jobs_to_hide = $.map(data.jobs_to_hide, function(str){
						return "job_"+str;
					});
					console.log(jobs_to_hide)
					ukcoursemap.graph.filter(jobs_to_hide);
				}
			});
			return false;
		});

	}

};