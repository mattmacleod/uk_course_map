// Main launch function
var ukcoursemap = {

		init: function(){
			this.graph.setup();
		}
};

$(document).bind("ready page:load", function(e){
	ukcoursemap.init();
});
