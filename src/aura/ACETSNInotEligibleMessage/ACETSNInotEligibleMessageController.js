({
	doInit : function(component) {
       // alert('test123');
       component.set('v.displayval', false);
        component.set('v.message', '');
		var action1 = component.get("c.FetchSniEligibleStatus");
         action1.setParams({
             "pAccId": component.get("v.recordId")
        });
        action1.setCallback(this, function(response1) {
            var state1 = response1.getState();
            console.log('state1-------'+state1);
            console.log('response1-------'+response1);
            if(state1 == 'SUCCESS') {
                var result1 = response1.getReturnValue();
                console.log('result1-------'+result1);
                console.log('result1 statusCode-------'+result1.statusCode);
               // if(result1.statusCode == 200){
                    console.log('result1  value -----'+result1);
                     if(result1 != '' ){
                         console.log('Family is no longer SNI Eligible');
                         component.set('v.displayval', true);
                           component.set('v.message', result1); 
                           // "'Family is no longer SNI Eligible.  Cancel service lines and work orders with Cancel Reason 'Ineligible for SNI'."
                         
                     }
                //}
            }
            else{
                
            }
        });
         $A.enqueueAction(action1);
	}
})