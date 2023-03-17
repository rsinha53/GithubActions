({
	launchNPS : function(component, event, helper) {
        setTimeout(function(){
            try {
        		QSI.API.load();
                QSI.API.run();
                //console.log("QSI CALLED");
    		} 
    		catch (err) {
                //console.log("ERROR: " + err.message);
			}       
        }, 1000);   
   }
})