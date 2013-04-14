// Main launch function
var ukcoursemap = {

		init: function(){
			ukcoursemap.graph.setup();
		}
};

$(document).bind("ready page:load", function(e){
	ukcoursemap.init();
});
