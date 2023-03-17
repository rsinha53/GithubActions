({
    getMedicalClaims: function(component, event, helper){
        var userId = component.get("v.agentUserId"); //"pchinnol"; 
        var memberId = 'S'+component.get("v.decodedMemberId"); //"S994061057";
        var policy = component.get("v.memberPolicy"); //"0701648";

        console.log('----------------------------------policy', policy);
        var memFirstName = component.get("v.firstName"); //"0701648";
        var relationship = component.get("v.memberRelationID"); //"RR" 
        var consumerApplication = "Acet"; 
        // policy='000001';
        var action = component.get("c.getMedicalClaims");


        console.log('----------------------------------userId', userId);
        console.log('----------------------------------memberId', memberId);
        console.log('----------------------------------policy', policy);
        console.log('----------------------------------memFirstName', memFirstName);
        console.log('----------------------------------relationship', relationship);
        console.log('----------------------------------consumerApplication', consumerApplication);

        action.setParams({ 
            userId : userId,
            memberId : memberId,
            policy : policy,
            memFirstName : memFirstName,
            relationship : relationship,
            consumerApplication : consumerApplication}); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var claimsList = [], finalClaimList = [];
                var claimDetails = response.getReturnValue();
                if(claimDetails!= null && claimDetails.searchResult != null){ 
                    if(claimDetails.searchResult.searchOutput != null){ 
                        claimsList = claimDetails.searchResult.searchOutput.claims;
                    }  
                    var errorList = claimDetails.searchResult.errors;
                    if (errorList != undefined && errorList.length != 0) {
                        for (var key in errorList){
                            // check authorization persons and set error message
                            var errorCode = errorList[key].code; 
                            var errorName = errorList[key].name; 
                            var errorDescription = errorList[key].description; 
                            if((errorCode == '400') && (errorName == 'InvalidSecurityFault')){
                                if((errorDescription.includes("[8]"))&&(errorDescription.includes("[998]"))){
                                    component.set("v.unAuthorizedMsg", true);
                                }
                            }
                        }
                    }
                    // Sort Medical Claim list   
                    if (claimsList != undefined && claimsList.length != 0) {     
                        var sortedClaims = this.sortList(component,claimsList,'firstServiceDate');
                        component.set("v.mediClaimDetails", sortedClaims);
                    }
                }
                this.fireUnAuthMsgEvent(component, event, helper);
            }
            component.set('v.showSpinner',false);
        });
        $A.enqueueAction(action);  
    },
    
    sortList: function(component, records, field) {
        var sortAsc = false;
        records.sort(function(a,b){
            if(a[field] != '' && a[field] != null && b[field] != '' && b[field] != null){
                var t1 = new Date(a[field]) == new Date(b[field]),
                    t2 = new Date(a[field]) > new Date(b[field]);
                
                console.log('dates-->'+new Date(a[field])+'-->'+b[field] );
                return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
            }else if(a[field] == undefined || a[field] == ''){
                console.log('blank date'+a[field]);
                return 1;
            }
                else if(b[field] == undefined || b[field] == ''){
                    return -1;
                }
            
        });
        return records;
    },
    
    fireUnAuthMsgEvent : function(component, event, helper){
        var cmpEvent = component.getEvent("unAuthMsgEvent"); 
        var mediClaimDetails = component.get("v.mediClaimDetails");
        var unAuthorizedMsg = component.get("v.unAuthorizedMsg");
        cmpEvent.setParams({
            "mediClaimDetails" : mediClaimDetails,
            "unAuthorizedMsg" : unAuthorizedMsg
        }); 
        cmpEvent.fire();
    }
})