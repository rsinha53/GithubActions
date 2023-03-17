({
	setup : function(component, event, helper) {
        var action1 = component.get('c.getUserDetail');
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                try{
                    var registrationDateValue = response.getReturnValue().FamilyLink_Registration_Date;
                    component.set('v.FamilyLink_Registration_Date', registrationDateValue);
                    var NPSrecordId = response.getReturnValue().NPSrecordId;
                    component.set('v.QualtricsData', NPSrecordId);
                    if(registrationDateValue != undefined && registrationDateValue != null && registrationDateValue != ''){
                        let [year, month, day] = registrationDateValue.split("-");
                    	var registrationDateObj = new Date(year,Number(month)-1,day,0,0,0,0);
                        //console.log("REGISTRATION DATE: " + registrationDateObj);
                    	var twoWeeksDateObj = new Date();
                        twoWeeksDateObj.setHours(0,0,0,0);
                        twoWeeksDateObj.setDate(twoWeeksDateObj.getDate()-14);
                        //console.log("DATE 14 DAYS AGO: " + twoWeeksDateObj);
                        
                        //If Registration date is at least 14 days ago, call qualtrics
                        //This logic handles the 14 day delay for the first pop of the NPS survey
                        //After the first launch then qualtrics handles the remaining delays
                        if(registrationDateObj.getTime() <= twoWeeksDateObj.getTime()){
                        	helper.launchNPS(component, event, helper); 
                    	}
                    }
                }
                catch(error){
                    //console.log("***ERROR: " + error.message());
                }
            }
        });
        $A.enqueueAction(action1);
	}
})