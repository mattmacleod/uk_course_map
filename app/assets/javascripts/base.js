// Main launch function
var ukcoursemap = {

		init: function(){
			ukcoursemap.graph.setup();
			ukcoursemap.search.setup();
			ukcoursemap.lightbox.setup();
		}
};

$(document).bind("ready page:load", function(e){
	ukcoursemap.init();
});
