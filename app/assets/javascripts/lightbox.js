ukcoursemap.lightbox = {

	setup: function(){
		// Bind to show event
		$("h1").on("click", function(){
			ukcoursemap.lightbox.show("/detail");
		});
	},

	show: function( url ){

		var $lightbox_overlay = $("<div id='lightbox_overlay' class='hidden_in'/>");
		var $lightbox_content = $("<div id='lightbox_content'/>");
		var $lightbox_inner   = $("<div id='lightbox_inner'/>");
		var $lightbox_iframe  = $("<iframe id='lightbox_iframe'/>");

		$lightbox_inner.append( $lightbox_iframe.attr("src", url) );

		$("body").append(
			$lightbox_overlay.append( $lightbox_content.append( $lightbox_inner ) )
		);
		window.setTimeout(function(){
			$lightbox_overlay.removeClass("hidden_in");
		}, 100);
		$lightbox_overlay.on("click", ukcoursemap.lightbox.hide);

	},

	hide: function(){
		$("#lightbox_overlay").addClass("hidden_out");
		window.setTimeout(function(){
			$("#lightbox_overlay").remove();
		}, 333);
	}

};