({
 	getMemberDetails : function(component, event, helper) {
        
       var recordId=  component.get('v.recordId');
       var action = component.get('c.getMemberDetails');
       action.setParams({
            "recordId" : recordId
         });
        
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                if(!res.ErrorOccured){
                    
                	var memberDocList = res.MemberDocuments;
					for(var i = 0; i < memberDocList.length; i++){
						var options = { year: 'numeric', month: 'long', day: 'numeric' };
                        var tempDate = new Date(memberDocList[i].LastModifiedDate);
						memberDocList[i].LastModifiedDate = tempDate.toLocaleDateString("en-US", options);
					}
                    var memProgHistory = res.MemberProgramHistory;
                    var day;
                    var month;
                    var year;
                    var months = ["months","January","February","March","April","May","June","July","August","September",
                                     "October","November","December"];
					for(var i = 0; i < memProgHistory.length; i++){
                    
                        var datarow = memProgHistory[i].inActiveDate.split('-');
                        var monthnum = parseInt(datarow[1], 10);
                        month = months[monthnum];
                        year = datarow[0];
                        day = datarow[2];
                        memProgHistory[i].inActiveDate = month +' '+day+', '+year;
                        
                        var datarow = memProgHistory[i].enrollmentDate.split('-');
                        var monthnum = parseInt(datarow[1], 10);
                        month = months[monthnum];
                        year = datarow[0];
                        day = datarow[2];
                        memProgHistory[i].enrollmentDate = month +' '+day+', '+year;
                          
					}
                    var activeSection = "";
                    if(memberDocList.length > 0){
                        activeSection = "A";
                    }
                    component.set('v.activeSection',activeSection);
                    component.set('v.memberRecord', res.MemberDetailsRecord);
               		component.set('v.memberDocuments', memberDocList);
                    component.set('v.memberProgramHistory', memProgHistory);
                } else {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire();     
                }  
            }
        });
        
        $A.enqueueAction(action);
	},
    checkIfMobileDevice : function(component, event, helper){
        var isMobile = false;
        if (navigator.userAgent.match(/Android/i) 
            || navigator.userAgent.match(/webOS/i) 
            || navigator.userAgent.match(/iPhone/i)  
            || navigator.userAgent.match(/iPad/i)  
            || navigator.userAgent.match(/iPod/i) 
            || navigator.userAgent.match(/BlackBerry/i) 
            || navigator.userAgent.match(/Windows Phone/i)) { 
            isMobile = true; 
        } else {
            isMobile = false; 
        }
        component.set('v.isMobileDevice', isMobile);
    },
   
})