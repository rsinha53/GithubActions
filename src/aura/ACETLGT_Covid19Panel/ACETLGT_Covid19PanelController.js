({
    doInit: function(component, event, helper) {
        var action = component.get("c.getCovidVaccineDetails");
        var firstName = component.get("v.fName");
        var lastName = component.get("v.lName");
        var dob = component.get("v.dob");

        if(firstName != null && lastName != null && dob != null){
        action.setParams({
            subjectFNm: firstName,
            subjectLNm: lastName,
            dob: dob
        });
        action.setCallback(this, function(a) {
            //get the response state
            var state = a.getState();
            console.log("covid state---" + state);
            //check if result is successfull
            if (state == "SUCCESS") {
                var result = a.getReturnValue();
                console.log("covid result--------" + result);
                component.set("v.covidData", result);
            }
        });
        $A.enqueueAction(action);
        }
    }
});